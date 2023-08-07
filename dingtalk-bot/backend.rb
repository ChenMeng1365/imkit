#coding:utf-8

class Backend < Sinatra::Base
  configure do
    set :bind, '0.0.0.0'
    set :port, 4074

    set :public_folder, "#{$data}/public"
    set :views, 'views'

    set :server, 'puma'

    enable :sessions, :logging
  end

  not_found do
    # redirect to('/404')
    %Q{<div align=center><a href='/'><img src="/images/jianshu-404.png"></img></a></div>}
  end
end
