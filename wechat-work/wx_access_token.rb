#coding:utf-8
$LOAD_PATH << "."
require 'lib/helper'

# 手动获取access token
data         = "/home/yui/datahouse"
conf         = YAML.load(File.read("#{data}/wechat/config.yml"))['wxwork']['app']
corpId       = conf['corpId']
corpSecret   = conf['corpSecret']

access_token = WXHelper.get_access_token corpId, corpSecret
puts access_token

