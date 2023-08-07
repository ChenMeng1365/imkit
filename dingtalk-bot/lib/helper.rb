#coding:utf-8

module DTHelper
  module_function

  def verify_time timestamp
    local_time = Time.new
    remote_time = Time.new(1970,1,1,0,0,0)+timestamp.to_i/1000
    return (local_time-remote_time).abs <= 3600
  end

  def verify_sign appSecret, timestamp
    # timestamp = ((Time.now - Time.new(1970,1,1,0,0,0))*1000).round
    message = "#{timestamp}\n#{appSecret}"
    hash = OpenSSL::HMAC.digest('sha256', appSecret, message)
    signatrue = Base64.encode64(hash).strip
  end

end
