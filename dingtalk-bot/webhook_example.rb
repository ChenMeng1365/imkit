#coding:utf-8
require 'dingbot'

# https://github.com/thierryxing/dingtalk-bot

$data = '/home/yui/datahouse/dingtalk'

DingBot.configure do |config|
  config.endpoint = 'https://oapi.dingtalk.com/robot/send' # API endpoint URL, default: ENV['DINGTALK_API_ENDPOINT'] or https://oapi.dingtalk.com/robot/send
  config.access_token = YAML.load(File.read "#{$data}/webhook.yml").find{|r|r['name']=='Rescute'}['token'] # access token, default: ENV['DINGTALK_ACCESS_TOKEN']
end

PHONE = '139xxxxxxxx'

begin # text
  message = "simple text"
  message = DingBot::Message::Text.new("p2p message",[PHONE],false)
end

begin # link
  message = DingBot::Message::Link.new( '标题', '简介', 'link.url', 'image.url')
end

begin # markdown
  DingBot.send_markdown('title', '# context')
  message = DingBot::Message::Markdown.new('title', "##### context @#{PHONE} ", [PHONE], hidden_reply=false)
end

begin # actionCard
  message = DingBot::Message::WholeActionCard.new(
      'title',
      '![screenshot](@pic_url) title',
      'guide_bar',
      'article_url'
  )
 message = DingBot::Message::IndependentActionCard.new(
      'title',
      '![screenshot](@pic_url) title',
      [
          DingBot::Message::ActionBtn.new('ok', 'yes, entry.'),
          DingBot::Message::ActionBtn.new('forget it', 'yes, another entry.')
      ]
  )
end

begin # feedCard
  message = DingBot::Message::FeedCard.new(
      [
          DingBot::Message::FeedCardLink.new(
              'title',
              'pic_url',
              'links'
          ),
          DingBot::Message::FeedCardLink.new(
              'another title',
              'another pic_url',
              'another links'
          )
      ]
  )
end

DingBot.send_msg(message)

