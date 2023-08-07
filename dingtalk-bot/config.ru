#coding:utf-8
$LOAD_PATH.unshift "."

###############################################################
# libraries
###############################################################
require 'net/http'
require 'uri'
require 'openssl'
require 'base64'
require 'yaml'
require 'neatjson'


###############################################################
# tools & components
###############################################################
require 'lib/helper'
require 'lib/talker'


###############################################################
# frameworks
###############################################################
require 'sinatra'


###############################################################
# initialize
###############################################################
$data = "/home/yui/datahouse"
$config = YAML.load(File.read "#{$data}/dingtalk/config.yml")


###############################################################
# web control
###############################################################
require 'backend'

require 'models/index'
require 'controllers/index'


###############################################################
# system running
###############################################################
use Rack::Session::Pool, :expire_after => 86400
run Backend
