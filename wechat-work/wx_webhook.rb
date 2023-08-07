#coding:utf-8
$LOAD_PATH << "."
require 'lib/helper'

# 手动调用webhook，将消息发到webhook关联的群UI上
data    = "/home/yui/datahouse"
conf    = YAML.load(File.read("#{data}/wechat/config.yml"))['wxwork']['app']
webhook = conf['webhook']
msg     = ARGV[0]

WXHelper.send_hook_msg webhook, msg

