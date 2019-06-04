# frozen_string_literal: true

require 'bundler/setup'
require_relative 'system/container'
require 'dry/events'
require 'dry/monitor/notifications'
require 'dry/system/dependency_graph'

App.register(:dependency_graph, Dry::System::DependencyGraph.new(App[:notifications]))

App.finalize!
p App.keys

events = App[:dependency_graph].events
pp events

puts '*'*80

nodes = events[:registered_dependency].map do |event|
  [event[:class_name].name, { label: event[:key].to_s }]
end

pp nodes
puts '*'*80

edges = events[:resolved_dependency].flat_map do |event|
  event[:dependency_map].map do |_alias, key|
    inject_class = nodes.find { |node| node.last[:label] == key }.first
    [event[:target_class].name, inject_class]
  end
end

pp edges
puts '*'*80

require 'ruby-graphviz'

# Create a new graph
g = GraphViz.new(:DrySystemDependencyGraph, type: :digraph)

# Create two nodes
nodes.each { |node| g.add_nodes(*node) }
edges.each { |edge| g.add_edges(*edge) }

# Generate output image
g.output( png: "dependency_graph.png" )


# App['service_with_dependency']
# user_repo = App['user_repo']
#
# puts user_repo.db.inspect
