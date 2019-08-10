require 'erb'
require 'json'
require 'sinatra/base'

module Dry
  module System
    module DependencyGraph
      class Web < Sinatra::Base
        set :root, File.expand_path(File.dirname(__FILE__) + "/../../../../web")
        set :views, Proc.new { "#{root}/views" }
        set :container, Proc.new { fail }

        get '/' do
          dependency_graph = settings.container[:dependency_graph]

          @xdot = dependency_graph.graph.output(xdot: String)
          @dependencies_calls = dependency_graph.dependencies_calls

          erb :graph
        end

        get '/info/:key' do
          content_type :json

          dependency_graph = settings.container[:dependency_graph]
          dependency_graph.dependency_information(params['key']).to_json
        end
      end
    end
  end
end
