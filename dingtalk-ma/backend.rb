#coding:utf-8
$LOAD_PATH << "." << "./lib"
require 'helper'
require 'sinatra'

begin
  $data      = "/home/yui/datahouse"
  $config    = YAML.load(File.read("#{$data}/dingtalk/config.yml"))
  app        = $config['dtma'].find{|a|a['Name']=='Rwby'}
  app_key    = app['AppKey']
  app_secret = app['AppSecret']
end

configure do
  set    :bind,          '0.0.0.0'
  set    :port,          4074
  set    :server,        'puma'
  set    :public_folder, "#{$data}/public"
  set    :views,         'views'
  enable :sessions,      :logging
end

Dir["models/*"     ].each{|path|require path}
Dir["controllers/*"].each{|path|require path}

