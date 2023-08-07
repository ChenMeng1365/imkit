#coding:utf-8
$LOAD_PATH << "."
require 'lib/helper'

# 手动获取access token
data         = "/home/yui/datahouse"
conf         = YAML.load(File.read("#{data}/wechat/config.yml"))['wxwork']['app']
corpId       = conf['corpId']
corpSecret   = conf['corpSecret']

access_token = WXHelper.get_access_token corpId, corpSecret
list = WXHelper.get_wx_ip access_token

range = list.map do|item|
  if item.include?(".*")
    item.sub(".*",".0/24") if item.include?(".*")
  else
    item+"/32"
  end
end.join("\n")
puts range

