require "dry/system/dependency_graph/version"
require "dry/system/dependency_graph/base"

module Dry
  module System
    module DependencyGraph
      class Error < StandardError; end

      class << self
        # Initialize dependency graph library
        #
        # @param notifications [Object] the dry system container notifications object
        #
        # @since 0.1.0
        #
        # @example base usage
        #
        #   App.register(:dependency_graph, Dry::System::DependencyGraph.new(App))
        #   App.finalize!
        #   App[:dependency_graph].events
        def new(container)
          Base.new(container)
        end
        alias initialize new

        # Initialize dependency graph library
        #
        # @param notifications [Object] the dry system container notifications object
        #
        # @since 0.1.0
        #
        # @example base usage
        #
        #   Dry::System::DependencyGraph.register!(App)
        #
        #   App.finalize!
        #   App[:dependency_graph].events
        def register!(container)
          instance = self.new(container)
          container.register(:dependency_graph, instance)
        end
      end
    end
  end
end
