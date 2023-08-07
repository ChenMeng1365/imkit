#coding:utf-8
$LOAD_PATH << "."
require 'lib/helper'
require 'sinatra'

begin
  conf             = YAML.load(File.read("/workspace/database/wechat.yml"))['wxgz']['msg-pusher']
  url              = conf['url']
  token            = conf['token']
  encoding_aes_key = conf['encoding-aes-key']
  pattern          = conf['pattern']
  msg_type         = conf['msg-type']
end

configure do
  set :bind,          '0.0.0.0'
  set :port,          80
  set :server,        'puma'
  #set :public_folder, 'public'
  enable :sessions,   :logging
end

not_found do
  "<div align='center'>#{request.ip}</div>"
  #  1000000.times.map{(33+rand(93)).chr}.join
end

get '/wxgz' do
  [:signature, :timestamp, :nonce, :echostr].each do|tag|
    eval(%Q{@#{tag} = "#{params[tag]}"})
  end
  list = [token, @timestamp, @nonce].sort.join
  digest = Digest::SHA1.hexdigest(list)
  
  if @signature==digest
    @echostr  
  else
    ""
  end
end

