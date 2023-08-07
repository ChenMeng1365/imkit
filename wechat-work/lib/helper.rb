#coding:utf-8
require 'openssl'
require 'base64'
require 'neatjson'
require 'yaml'

module WXHelper
  ###############################################################
  # 获取access token 
  # https://work.weixin.qq.com/api/doc#90000/90135/91039
  ###############################################################
  def self.get_access_token corpId, corpSecret
    response     = `curl -s "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=#{corpId}&corpsecret=#{corpSecret}"`
    access_token = JSON.parse(response)['access_token']
  end
 
  ###############################################################
  # 获取微信服务器地址段 
  # https://work.weixin.qq.com/api/doc#90000/90135/90237
  ###############################################################
  def self.get_wx_ip access_token
    response = `curl -s "https://qyapi.weixin.qq.com/cgi-bin/getcallbackip?access_token=#{access_token}"`
    ip_list  = JSON.parse(response)['ip_list']
  end  

  ###############################################################
  # 验证应用服务器URL、接收消息
  # https://work.weixin.qq.com/api/doc#90000/90135/90237 
  # 解密消息内容
  # https://work.weixin.qq.com/api/doc#90000/90139/90968
  ###############################################################
  # step.1. prepare arguments
  def self.get_arguments opts
    list = opts.split("&").inject({})do|list,arg|
      key,value = arg.split("=")
      list[key] = value.gsub("%3D","=").gsub("%2F","/").gsub("%2B","+")
      list
    end
    return list
  end

  # step.2. verify signature(should equal msg_signature)
  def self.verify_url token,list
    Digest::SHA1.hexdigest([ token,list['timestamp'] , list['nonce'], list['echostr'] ].sort.join)
  end

  # step.3. decrypt message
  # <xml>
  #   <ToUserName><![CDATA[...]]></ToUserName>
  #   <FromUserName><![CDATA[...]]></FromUserName>
  #   <CreateTime><![CDATA[...]]></CreateTime>
  #   <MsgType><![CDATA[...]]></MsgType>
  #   <Content><![CDATA[...]]></Content>
  #   <MsgId><![CDATA[...]]></MsgId>
  #   <AgentID><![CDATA[...]]></AgentID>
  # </xml>
  def self.decrypt list,encodingAESKey
    aes = OpenSSL::Cipher.new("AES-256-CBC")
    aes.key = Base64.decode64(encodingAESKey+"=")
    cipher = Base64.decode64(list['echostr'])
    rand_msg = aes.update(cipher)
  
    content = rand_msg[16..-1]
    msg_len = eval("0x"+content[0..3].split('').map{|c|"%02x"%c.ord}.join)
    msg = content[4..(4+msg_len-1)]
    receiveid = content[(4+msg_len)..-1]
    return msg,receiveid
  end

  ###############################################################
  # 发送消息
  # https://work.weixin.qq.com/api/doc#90000/90135/90236
  ###############################################################
  # 对用户接口推送
  def self.send_agent_msg agentId, access_token, userId, msg
    system %Q{ curl -s "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=#{access_token}" -H "application/json" -d '{ "touser" : "#{userId}", "msgtype" : "text", "agentid" : #{agentId}, "text" : { "content" : "#{msg}" }, "safe":0, "enable_id_trans": 0 }' }
  end

  # 对群推送
  def self.send_hook_msg webhook,msg
    system %Q{curl -s "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=#{webhook}" -H 'Content-Type: application/json' -d '{ "msgtype": "markdown", "markdown": { "content": "#{msg}" } }'}
  end 

end

