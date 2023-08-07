#coding:utf-8
require 'digest/sha1'
require 'yaml'
require 'neatjson'

module DTHelper
  extend self

  #######################################################################
  # 获取access_token
  # https://ding-doc.dingtalk.com/doc#/serverapi2/eev437
  #######################################################################
  def get_access_token app_key, app_secret
    result = `curl -s "https://oapi.dingtalk.com/gettoken?appkey=#{app_key}&appsecret=#{app_secret}"`
    JSON.parse(result)['access_token']
  end
  
  def get_jsapi_ticket access_token
    result = `curl -s "https://oapi.dingtalk.com/get_jsapi_ticket?access_token=#{access_token}"`
    JSON.parse(result)["ticket"]
  end

  def sign ticket, nonceStr, timeStamp, url
    plain = "jsapi_ticket=#{ticket}&noncestr=#{nonceStr}&timestamp=#{timeStamp}&url=#{url}"
    digest = Digest::SHA1.hexdigest(plain)
    digest.split('').map{|c|"%02x"%c.ord}.join
  end

  def code number
    alphabet = ('a'..'z').to_a+('A'..'Z').to_a+(0..9).to_a # +%Q{~`!@#$%^&*()-_=+{}[]|\;:'",<.>?/}.split('')
    number.times.map{alphabet.shuffle.first}.join
  end

end

