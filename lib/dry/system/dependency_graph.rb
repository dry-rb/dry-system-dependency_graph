require "dry/system/dependency_graph/version"
require "dry/system/dependency_graph/base"

module Dry
  module System
    module DependencyGraph
      class Error < StandardError; end

      class << self
        # Initialize dependency graph library
        #
        # @param container [Object] the dry system container notifications object
        #
        # @since 0.1.0
        #
        # @example base usage
        #
        #   App.register(:dependency_graph, Dry::System::DependencyGraph.new(App))
        #   App.finalize!
        #   App[:dependency_graph].graph
        def new(container)
          Base.new(container)
        end
        alias initialize new

        # Initialize dependency graph library
        #
        # @param container [Object] the dry system container object
        # @param realtime_calls_adapter [Object] the adapter for collecting realtime calls metrics
        #
        # @since 0.1.0
        #
        # @example base usage
        #
        #   Dry::System::DependencyGraph.register!(App)
        #
        #   App.finalize!
        #   App[:dependency_graph].graph
        #
        # @example enable real time calls metrics
        #
        #   adapter = Dry::System::DependencyGraph::RealtimeAdapters::Redis.new(redis)
        #   # or
        #   adapter = Dry::System::DependencyGraph::RealtimeAdapters::Memory.new
        #
        #   Dry::System::DependencyGraph.register!(App, realtime_calls_adapter: adapter)
        #
        #   App.finalize!(freeze: false)
        #   App[:dependency_graph].enable_realtime_calls!
        #   App.freeze
        #
        #   # ...
        #   App[:dependency_graph].dependencies_calls
        def register!(container, realtime_calls_adapter: nil)
          instance = self.new(container)
          container.register(:dependency_graph, instance)
        end
      end
    end
  end
end
