require 'ruby-graphviz'

module Dry
  module System
    module DependencyGraph
      class GraphBuilder
        def call(events)
          nodes = calculate_nodes(events)
          edges = calculate_edges(events, nodes)

          graph_object = GraphViz.new(:DrySystemDependencyGraph, type: :digraph)

          group_by_keys(nodes).each do |cluster_name, cluster_nodes|
            cluster_graph = graph_object.add_graph("cluster.#{cluster_name}", label: "#{cluster_name} scope")
            cluster_nodes.each { |node| cluster_graph.add_nodes(*node) }
          end

          edges.each { |edge| graph_object.add_edges(*edge) }

          graph_object
        end

      private

        def calculate_nodes(events)
          events[:registered_dependency].map { |event| [event[:class].name, { label: event[:key].to_s }] }
        end

        def group_by_keys(nodes)
          nodes.group_by do |class_name, payload|
            scope = payload[:label].split('.').first
            scope == payload[:label] ? 'other' : scope
          end
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
