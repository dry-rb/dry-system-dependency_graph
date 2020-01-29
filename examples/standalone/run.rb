# frozen_string_literal: true

require 'json'
require 'bundler/setup'
require_relative 'system/container'
require 'dry/events'
require 'dry/monitor/notifications'
require 'dry/system/dependency_graph'

Dry::System::DependencyGraph.register!(App)

ns = Dry::Container::Namespace.new('persistance') do
  register('users') { Array.new }
end
App.import(ns)

App.finalize!

# App[:dependency_graph].graph.output( png: "dependency_graph.png" )

pp App[:dependency_graph].json_graph.to_json

# puts App[:dependency_graph].graph.output( xdot: String )

# App['services.service_with_dependency']
# user_repo = App['repositories.user_repo']
#
# puts user_repo.db.inspect
