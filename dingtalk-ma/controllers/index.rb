#coding:utf-8

not_found do
  %Q{<div align=center><a href='/'><img src="/images/jianshu-404.png"></img></a></div>}
end

get '/' do
  erb :index
end

post '/' do
  's'
end
