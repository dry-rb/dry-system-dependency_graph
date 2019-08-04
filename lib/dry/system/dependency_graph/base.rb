require_relative './graph_builder'

module Dry
  module System
    module DependencyGraph
      class Base
        attr_reader :graph_builder, :dependencies_calls

        def initialize(container, graph_builder: Dry::System::DependencyGraph::GraphBuilder.new)
          @events = {}
          @container = container
          @notifications = container[:notifications]
          @graph_builder = graph_builder
          @dependencies_calls = {}

          register_subscribers
        end

        def graph
          @dependency_graph ||= graph_builder.call(@events)

          @dependency_graph.each_graph do |scope_name, g|
            g.each_node do |name, node|
              label = node[:label].to_s.gsub( "\"", "" )
              node[:style] = 'filled'
              node[:fillcolor] = get_node_color(dependencies_calls[label])
              node[:tooltip] = "Calls count: #{dependencies_calls[label]}"
            end
          end

          @dependency_graph
        end

        def enable_realtime_calls!
          keys_for_monitoring.each do |key|
            dependencies_calls[key] = 0 
            @container.monitor(key) { |_event| dependencies_calls[key] += 1  }
          end
        end

      private

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

        def keys_for_monitoring
          @container.keys - [:dependency_graph, 'dependency_graph', :notifications, 'notifications']
        end

        def get_node_color(calls_count)
          case calls_count
          when nil then 'white'
          when 0 then '/bugn8/1'
          when 1..3 then '/bugn8/2'
          when 4..7 then '/bugn8/3'
          else
            '/bugn8/4'
          end
        end
      end
    end
  end
end
