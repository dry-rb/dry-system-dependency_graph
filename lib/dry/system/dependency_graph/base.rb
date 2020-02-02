require_relative './graph_builder'
require_relative './dependency_info'

module Dry
  module System
    module DependencyGraph
      class Base
        attr_reader :graph_builder, :dependencies_calls, :container

        def initialize(
          container,
          graph_builder: Dry::System::DependencyGraph::GraphBuilder.new
        )
          @events = {}
          @container = container
          @notifications = container[:notifications]
          @graph_builder = graph_builder
          @dependencies_calls = {}

          register_subscribers
        end

        def graph
          @dependency_graph ||= graph_builder.call(@events)
        end

        def enable_realtime_calls!
          keys_for_monitoring.each do |key|
            dependencies_calls[key] = 0 
            container.monitor(key) { |_event| dependencies_calls[key] += 1  }
          end
        end

        def dependency_information(class_name)
          DependencyInfo.new.call(class_name)
        end

        def merge_container!(container)
          return unless container[:dependency_graph]

          # TODO: make merging strategy for graphs
          graph
          # if a.first == 'dependency_graph'
          #   _container['dependency_graph'].call.graph.add_graph(other._container['dependency_graph'].call.graph)
          # end
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
          container.keys.delete_if { |k| k[/notification/] || k[/dependency_graph/] }
        end

        # TODO: move it to separate class and use DI for better configuration
      end
    end
  end
end
