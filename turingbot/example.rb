#coding:utf-8
$LOAD_PATH.unshift "."
require 'helper'
require 'callbot'

path     = "/home/yui/datahouse/turingbot"
config   = Dir["#{path}/config*.yml"][1]
template = Dir["#{path}/template_text.json"].first
report   = path.gsub("turingbot","report")

Dir.mkdir report unless File.exist? report
ai = TuringBot.new(config, template)
robot = ai.name # Turing.name(config)
dialog = []

print "YOU: "
loop do
  talk = gets.chomp#.force_encoding("GBK").encode('UTF-8')
  dialog << "YOU: #{talk}"
  break if ['quit','exit','byebye'].include?(talk)
  reply = ai.reply talk # Turing.send_msg text: talk, conf: config, templ: template #, debug: 'json'
  dialog << "#{robot}: #{reply}"
  puts "#{robot}: #{reply}"
  print "YOU: "
end

File.write report+"/talk"+Time.new.strftime("%Y%m%d%H%M%S")+".txt",dialog.join("\n"+Array.new(32,"~").join+"\n")
