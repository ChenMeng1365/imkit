#coding:utf-8
$LOAD_PATH << "." << "./lib"
require 'helper'

$data        = "/home/yui/datahouse"
conf         = YAML.load(File.read("#{$data}/dingtalk/config.yml"))
app          = conf['dtma'].find{|a|a['Name']=='Rwby'}
app_key      = app['AppKey']
app_secret   = app['AppSecret']
access_token = DTHelper.get_access_token(app_key, app_secret)
ticket       = DTHelper.get_jsapi_ticket access_token

url          = "http://0.0.0.0:4074"
timeStamp    = ((Time.now - Time.new(1970,1,1,0,0,0))*1000).round
nonceStr     = DTHelper.code 8
signature    = DTHelper.sign ticket, nonceStr, timeStamp, url

jsapi_verify = DATA.read.gsub('((AgentId))',app['AgentId'].to_s)\
                        .gsub('((CorpId))',conf['general']['CorpId'])\
                        .gsub('((timeStamp))',timeStamp.to_s)\
                        .gsub('((nonceStr))',nonceStr)\
                        .gsub('((signature))',signature)

File.write "jsapi_verify.js", jsapi_verify

__END__
import {dd} from 'dingtalk-jsapi';

dd.config({
    agentId: '((AgentId))', // 必填，微应用ID
    corpId: '((CorpId))',//必填，企业ID
    timeStamp: '((timeStamp))', // 必填，生成签名的时间戳
    nonceStr: '((nonceStr))', // 必填，生成签名的随机串
    signature: '((signature))', // 必填，签名
    type: 0,   //选填。0表示微应用的jsapi,1表示服务窗的jsapi；不填默认为0。该参数从dingtalk.js的0.8.3版本开始支持
    jsApiList : [
        'runtime.info',
        'biz.contact.choose',
        'device.notification.confirm',
        'device.notification.alert',
        'device.notification.prompt',
        'biz.ding.post',
        'biz.util.openLink',
    ] // 必填，需要使用的jsapi列表，注意：不要带dd。
});
