require 'erubis'

module Dry
  module System
    module DependencyGraph
      class Middleware

        class TemplateBuilder
          def call(xdot, dependencies_calls)
            template = <<~TEMPLATE
              <html>
                <head>
                  <title>Dependency Graph</title>
                  <script src="//d3js.org/d3.v4.min.js"></script>
                  <script src="http://viz-js.com/bower_components/viz.js/viz-lite.js"></script>
                  <script src="https://github.com/magjac/d3-graphviz/releases/download/v0.1.2/d3-graphviz.min.js"></script>
                </head>
                <body>
                  <input type="hidden" id="test" value='<%== xdot =%>' style="display:none"/>
                  <div id="graph" style="text-align: center;"></div>

                  <div id="calls" style="text-align: center;">
                    <%== dependencies_calls =%>
                  </div>

                  <script>
                    window.onload = function() {
                      d3.select("#graph").graphviz().renderDot(document.getElementById('test').value)
                    }
                  </script>
                </body>
              </html>
            TEMPLATE

            Erubis::EscapedEruby.new(template).result(binding())
          end
        end

        attr_reader :container

        DEPENDENCY_GRAPH_PATH_REGEXP = %r{\A/dependency_graph\z}

        def initialize(app, options = {})
          @container = options[:container]
          @app = app
        end

        def call(env)
          req = Rack::Request.new(env)
          status, headers, response = @app.call(env)
          headers = Rack::Utils::HeaderHash.new(headers)

          if dependency_graph_path?(req)
            response = [
              TemplateBuilder.new.call(App[:dependency_graph].graph.output(xdot: String), App[:dependency_graph].dependencies_calls)
            ]

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
