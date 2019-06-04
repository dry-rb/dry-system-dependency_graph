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
        #   App.register(:dependency_graph, Dry::System::DependencyGraph.new(App[:notifications]))
        #   App.finalize!
        #   App[:dependency_graph].events
        def new(notifications)
          Base.new(notifications)
        end
        alias initialize new
      end
    end
  end
end
