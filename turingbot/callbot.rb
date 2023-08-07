#coding:utf-8

module Turing
  module_function
  def send_msg arguments={}
    option = {conf: "./config.yml",templ: "./template_text.json"}.merge(arguments)
    !option[:conf]  and (warn "缺少配置参数"; return nil)
    !option[:templ] and (warn "缺少配置参数"; return nil)
    !option[:text]  and (warn "未指定发送消息"; return nil)
    !File.exist?(option[:conf])  and (warn "不存在配置文件"; return nil)
    !File.exist?(option[:templ]) and (warn "不存在模板文件"; return nil)
    
    Replacement.init
    Replacement.merge YAML.load(File.read option[:conf])
    Replacement['text'] = option[:text]

    uri = URI(Replacement['api'])
    template = File.read option[:templ]
    data = TinText.instance(template)
    header = {'content-type': 'application/json'}

    response = Net::HTTP.post(uri, data, header)
    recv = JSON.parse(response.body)
    return recv if option[:debug]=='json'
    return recv["results"].map{|result|result["values"].values.join("")}.join("")
  end

  def name conf
    !File.exist?(conf) and (warn "不存在配置文件"; return nil)
    return YAML.load(File.read conf)['userName']
  end
end

class TuringBot
  attr_reader :name

  def initialize conf,templ
    @name = Turing.name(conf)
    @conf = conf
    @templ= templ
  end

  def reply talk
    return Turing.send_msg text: talk, conf: @conf, templ: @templ #, debug: 'json'
  end
end

__END__
puts Turing.send_msg text: 'msg',debug: 'json'
