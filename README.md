# imkit

这是一个IM工具的仓库，为IM提供一些扩展

启动方法一般是`nohup ruby backend.rb port xxxx >> running.log &`或者经典的`rackup -s puma -o 0.0.0.0 -p xxxx >> running.log &`

其中一些基础工具也做成了脚本供直接调用

## 微信公众号

```shell
wechat-oa
├── backend.rb
├── Gemfile
├── Gemfile.lock
└── lib
    └── helper.rb
```

<=To Be Continued=|

## 企业微信

```shell
wechat-work
├── backend.rb
├── Gemfile
├── Gemfile.lock
├── lib
│   └── helper.rb
├── wx_access_token.rb
├── wx_agent.rb
├── wx_srv_ip.rb
└── wx_webhook.rb
```

## 钉钉微应用

```shell
dingtalk-ma
├── access_token.rb
├── backend.rb
├── controllers
│   └── index.rb
├── Gemfile
├── Gemfile.lock
├── jsapi_auth.rb
├── jsapi_ticket.rb
├── jsapi_verify.js
├── lib
│   └── helper.rb
├── models
│   └── index.rb
├── run.sh
└── views
    └── index.erb
```

<=To Be Continued=|

还用到了dingtalk.open.js，存放在`$data/public/scripts`里

## 钉钉机器人

```shell
dingtalk-bot
├── backend.rb
├── config.ru
├── controllers
│   └── index.rb
├── Gemfile
├── Gemfile.lock
├── lib
│   ├── helper.rb
│   └── talker.rb
├── models
│   └── index.rb
├── msgpost_example.rb
├── rackup.sh
├── views
│   └── index.erb
└── webhook_example.rb
```

## 图灵机器人

```shell
turingbot
├── callbot.rb
├── example.rb
├── helper.rb
├── imdoc (*)
│   └── TinText
│       ├── cache.rb
│       ├── tin_text.rb
│       └── tum.rb
└── README.md
```

## Datahouse

这些项目的公共配置文件、日志、数据存放在`/home/xxx/datahouse`目录下，这里提供一个配置文件模板，数据库相关配置另算

## Backlog

`v0.1.0` 为WXGZ、WXQY、DTMA添加了基础的access token、push message功能（由于没有资质认证和outgoing接口，这部分工作陷入停滞）

`v0.2.0` 所有项目更名，适配了新的配置文件；钉钉更新了outgoing功能，为钉钉机器人添加了outgoing接口

`v0.3.0` 新增了图灵机器人
