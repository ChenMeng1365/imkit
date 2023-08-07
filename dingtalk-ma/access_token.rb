#coding:utf-8
$LOAD_PATH << "." << "./lib"
require 'helper'

$data      = "/home/yui/datahouse"
conf       = YAML.load(File.read("#{$data}/dingtalk/config.yml"))['dtma']
app        = conf.find{|a|a['Name']=='Rwby'}
app_key    = app['AppKey']
app_secret = app['AppSecret']

access_token = DTHelper.get_access_token(app_key, app_secret)
puts access_token

