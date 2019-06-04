require 'ruby-graphviz'

module Dry
  module System
    module DependencyGraph
      class Base
        def initialize(notifications)
          @events = {}
          @notifications = notifications

          register_subscribers
        end

        def register_subscribers
          @events[:resolved_dependency] ||= []
          @events[:registered_dependency] ||= []

          @notifications.subscribe(:resolved_dependency) do |event|
            @events[:resolved_dependency] << event.to_h
          end

          @notifications.subscribe(:registered_dependency) do |event|
            @events[:registered_dependency] << event.to_h
          end
        end

        def events
          @events
        end
        
        def graph
          @dependency_graph ||= build_graph
        end

      private

        def build_graph
          nodes = @events[:registered_dependency].map do |event|
            [event[:class_name].name, { label: event[:key].to_s }]
          end

          edges = @events[:resolved_dependency].flat_map do |event|
            event[:dependency_map].map do |_alias, key|
              inject_class = nodes.find { |node| node.last[:label] == key }.first
              [event[:target_class].name, inject_class]
            end
          end

          # Create a new graph
          graph_object = GraphViz.new(:DrySystemDependencyGraph, type: :digraph)

          # Create two nodes
          nodes.each { |node| graph_object.add_nodes(*node) }
          edges.each { |edge| graph_object.add_edges(*edge) }
          graph_object
        end
      end
    end
  end
end
