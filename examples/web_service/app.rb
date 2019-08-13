require 'sinatra/base'

class WebApp < Sinatra::Base
  get "/" do
    App.keys.join(' ')
  end

  get "/service_call" do
    App['services.other_service'].call
  end

  get "/create_user" do
    App['services.create_user'].call
  end
end
