require 'erb'
require 'yaml'
require 'sinatra/base'
require_relative './middleware/template_builder'

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
      end
    end
  end
end
