require 'sinatra/base'

class WebApp < Sinatra::Base
  get "/" do
    App.keys.join(' ')
  end

  get "/service_call" do
    App['services.other_service'].call
  end
end
