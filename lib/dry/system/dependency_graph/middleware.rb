require 'erubis'
require_relative './middleware/template_builder'

module Dry
  module System
    module DependencyGraph
      class Middleware
        attr_reader :container

        DEPENDENCY_GRAPH_PATH_REGEXP = %r{\A/dependency_graph\z}

        def initialize(app, options = {})
          @container = options[:container]
          @app = app
        end

        def call(env)
          req = Rack::Request.new(env)
          status, headers, response = @app.call(env)

          if dependency_graph_path?(req)
            graph = App[:dependency_graph].graph

            response = [
              TemplateBuilder.new.call(graph.output(xdot: String), App[:dependency_graph].dependencies_calls)
            ]

            headers = Rack::Utils::HeaderHash.new(headers)
            headers['Content-Length'] = response.first.to_s.size.to_s
          end

          [status, headers, response]
        end


        def dependency_graph_path?(req)
          req.path =~ DEPENDENCY_GRAPH_PATH_REGEXP
        end
      end
    end
  end
end
