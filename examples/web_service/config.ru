# frozen_string_literal: true

require 'bundler/setup'
require_relative 'system/container'
require 'dry/events'
require 'dry/monitor/notifications'
require 'dry/system/dependency_graph'
require_relative './app'

App.register(:dependency_graph, Dry::System::DependencyGraph.new(App))

ns = Dry::Container::Namespace.new('persistance') do
  register('users') { Array.new }
end
App.import(ns)

App.finalize!

use Rack::ContentType, "text/html"
use Rack::ContentLength

require 'dry/system/dependency_graph/middleware'
use Rack::ContentLength
use Dry::System::DependencyGraph::Middleware, container: App

run WebApp.new
