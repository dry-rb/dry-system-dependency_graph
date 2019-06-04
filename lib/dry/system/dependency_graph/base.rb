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

        def build_graph!
        end
      end
    end
  end
end
