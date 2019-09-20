# frozen_string_literal: true

require 'bundler/setup'
require_relative 'system/container'
require 'dry/events'
require 'dry/monitor/notifications'
require 'dry/system/dependency_graph'
require_relative './app'

Dry::System::DependencyGraph.register!(App)

ns = Dry::Container::Namespace.new('persistance') do
  register('users') { Array.new }
end
App.import(ns)

# TODO: doesn't work well
#
# OtherApp.register(:dependency, Object.new)
# App.import(other: OtherApp)
# App['other.dependency']

App.finalize!(freeze: false)
App[:dependency_graph].enable_realtime_calls!
App.freeze

require 'dry/system/dependency_graph/web'
Dry::System::DependencyGraph::Web.set :container, App

run Rack::URLMap.new(
  '/' => WebApp.new,
  '/dependency_graph' => Dry::System::DependencyGraph::Web.new(container: App)
)
