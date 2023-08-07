#coding:utf-8
$LOAD_PATH << "." << "./lib"
require 'helper'
require 'sinatra'

begin
  $data          = "/home/yui/datahouse"
  conf           = YAML.load(File.read("#{$data}/wechat/config.yml"))['wxwork']['app']
  agentName      = conf['agentName']
  corpId         = conf['corpId']
  agentId        = conf['agentId']
  token          = conf['token']
  encodingAESKey = conf['encodingAESKey']
  Dir.mkdir "#{$data}/log" unless File.exist? "#{$data}/log"
end

configure do
  set    :bind,          '0.0.0.0'
  set    :port,          8864
  set    :server,        'puma'
  set    :public_folder, "#{$data}/public"
  enable :sessions,      :logging
end

not_found do
  "<div align='center'>#{request.ip}</div>"
end

get '/' do
  if params[:msg_signature]
    opts = "msg_signature=#{params[:msg_signature]}&timestamp=#{params[:timestamp]}&nonce=#{params[:nonce]}&echostr=#{params[:echostr]}"
    list = WXHelper.get_arguments opts
    signature = WXHelper.verify_url token,list
    msg,receiveid = WXHelper.decrypt list,encodingAESKey
    msg
  else
    "<div align='center'>#{request.ip}</div>" # 1000000.times.map{(33+rand(93)).chr}.join
  end
end

post '/' do
  #################################################################
  # 
  # 用户对应用的消息/事件:(仅限对agent app)
  #
  # 用户消息/事件 --> 微信后台 --> 应用后台
  #
  # https://work.weixin.qq.com/api/doc#90000/90135/90237
  #
  #################################################################
  # 解析消息
  data = request.body.read
  encrypt = begin
    data.split("<Encrypt><![CDATA[")[1].split("]]></Encrypt>")[0]
  rescue
    "消息损坏!"
  end
  echostr = encrypt.gsub("=","%3D").gsub("/","%2F").gsub("+","%2B")

  opts = "msg_signature=#{params[:msg_signature]}&timestamp=#{params[:timestamp]}&nonce=#{params[:nonce]}&echostr=#{echostr}"
  list = WXHelper.get_arguments opts
  signature = WXHelper.verify_url token,list
  msg,receiveid = WXHelper.decrypt list,encodingAESKey
 
  user = begin
    msg.split("<FromUserName><![CDATA[")[1].split("]]></FromUserName>")[0]
  rescue
    nil # 不包含<FromUserName/>的消息，格式错误
  end

  event = begin
    msg.split("<Event><![CDATA[")[1].split("]]></Event>")[0]
  rescue
    nil # 任何操作都会被记录，需要一一解析
  end

  content = begin
    msg.split("<Content><![CDATA[")[1].split("]]></Content>")[0]
  rescue
    nil # 直接使用API向AGENT发送消息不会包含<Content/>，这里直接终结
  end
  
  
  # 记录消息
  File.open("#{$data}/log/wxwork-msg.log","a+"){|f|f.write "[#{Time.new+8*3600}]$#{agentName}(recv): #{msg}\n\n"}
  File.open("#{$data}/log/wxwork-msg.log","a+"){|f|f.write "[#{Time.new+8*3600}]$#{agentName}(send): @#{user} #{content}\n\n"} if content
 

  # 回复消息
  if content and user
    system %Q{ruby wx_agent.rb #{user} "#{content}"}
    # system %Q{ruby wx_webhook.rb "@#{user} #{content}"}
  end
end


