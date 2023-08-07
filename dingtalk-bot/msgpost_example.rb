#coding:utf-8

require 'net/http'
require 'uri'
require 'openssl'
require 'base64'
require 'yaml'
require 'neatjson'

require './lib/helper'

$data = "/home/yui/datahouse"
$config = YAML.load(File.read "#{$data}/dingtalk/config.yml")

bot = $config["dtbot"].find{|bot|bot['Name']=='Rescute'}
appSecret = bot['AppSecret']
timestamp = ((Time.now - Time.new(1970,1,1,0,0,0))*1000).round
signatrue = DTHelper.verify_sign appSecret, timestamp

uri = URI.parse("http://node105.numeron.net:4074/")

header = {}
header["Content-Type"] = "application/json; charset=utf-8"
header["timestamp"] = timestamp.to_s
header["sign"] = signatrue

data = JSON.parse('{
  "conversationId": "xxxx",
  "conversationType": "xxxx",
  "conversationTitle": "xxxx",
  "atUsers": [
    {
      "dingtalkId": "xxxx",
      "staffId": "xxxx"
    }
  ],
  "chatbotUserId": "xxxx",
  "msgId": "xxxx",
  "senderId": "xxxx",
  "senderNick": "xxxx",
  "senderCorpId": "xxxx",
  "senderStaffId": "xxxx",
  "isAdmin": true,
  "sessionWebhookExpiredTime": 1234,
  "createAt": 1234,
  "isInAtList": true,
  "sessionWebhook": "https://oapi.dingtalk.com/robot/sendBySession?session=xxxx",
  "text": {
    "content": "xxxx"
  },
  "msgtype": "text"
}')

resp = Net::HTTP.post(uri, URI.encode_www_form(data),header)  
puts header
puts resp.body

