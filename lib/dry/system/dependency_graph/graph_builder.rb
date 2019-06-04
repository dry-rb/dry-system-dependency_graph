require 'ruby-graphviz'

module Dry
  module System
    module DependencyGraph
      class GraphBuilder
        def call(events)
          nodes = calculate_nodes(events)
          edges = calculate_edges(events, nodes)

          # Create a new graph
          graph_object = GraphViz.new(:DrySystemDependencyGraph, type: :digraph)

          # Create two nodes
          nodes.each { |node| graph_object.add_nodes(*node) }
          edges.each { |edge| graph_object.add_edges(*edge) }
          graph_object
        end

      private

        def calculate_nodes(events)
          events[:registered_dependency].map { |event| [event[:class_name].name, { label: event[:key].to_s }] }
        end

        def calculate_edges(events, nodes)
          events[:resolved_dependency].flat_map do |event|
            event[:dependency_map].map do |label, key|
              inject_class = nodes.find { |node| node.last[:label] == key }.first
              [event[:target_class].name, inject_class, label: label]
            end
          end
        end
      end
    end
  end
end
