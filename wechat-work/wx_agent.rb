#coding:utf-8
$LOAD_PATH << "."
require 'lib/helper'

# 手动调用agent，将消息发到每个用户关联的agentUI上
data         = "/home/yui/datahouse"
conf         = YAML.load(File.read("#{data}/wechat/config.yml"))['wxwork']['app']
corpId       = conf['corpId']
corpSecret   = conf['corpSecret']

access_token = WXHelper.get_access_token corpId, corpSecret

agentId      = conf['agentId'].to_i
userId       = ARGV[0]
msg          = ARGV[1]

WXHelper.send_agent_msg agentId, access_token, userId, msg

