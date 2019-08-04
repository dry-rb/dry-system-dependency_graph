require_relative './graph_builder'

module Dry
  module System
    module DependencyGraph
      class Base
        attr_reader :graph_builder

        def initialize(container, graph_builder: Dry::System::DependencyGraph::GraphBuilder.new)
          @events = {}
          @notifications = container[:notifications]
          @graph_builder = graph_builder
          @dependencies_calls = {}

          container.register(:dependency_graph, self)

          register_subscribers
        end

        def graph
          @dependency_graph ||= graph_builder.call(@events)
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
      end
    end
  end
end
