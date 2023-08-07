#coding:utf-8

class Backend
  post "/" do
    # DingTalk outgoing message receiver
    erb "index".to_sym, locals: {data: params}
  end

  get "/" do
    "<center>"+request.host+"</center>"
  end
end
