# frozen_string_literal: true

require 'bundler/setup'
require_relative 'system/container'
require 'dry/events'
require 'dry/monitor/notifications'
require 'dry/system/dependency_graph'
require_relative './app'

Dry::System::DependencyGraph.register!(App)
Dry::System::DependencyGraph.register!(OtherApp)

ns = Dry::Container::Namespace.new('persistence') do
  register('users') { Array.new }
end
App.import(ns)

ns2 = Dry::Container::Namespace.new('domain') do
  register('repositories.accounts') { Object.new }
  register('operations.show') { Set.new }
end
App.import(ns2)

# OtherApp.register(:dependency, Object.new)
# OtherImport = OtherApp.injector
#
# class TestOtherServices
#   include OtherImport['dependency']
#
#   def call
#   end
# end
# OtherApp.register(:test_other_services, TestOtherServices.new)
# App.import(new_one: OtherApp)

# App.finalize!
App.finalize!(freeze: false)
# App[:dependency_graph].merge_container!(OtherApp)
# App[:dependency_graph].enable_realtime_calls!
App.freeze

require 'dry/system/dependency_graph/web'
Dry::System::DependencyGraph::Web.set :container, App

run Rack::URLMap.new(
  '/' => WebApp.new,
  '/dependency_graph' => Dry::System::DependencyGraph::Web.new(container: App)
)
