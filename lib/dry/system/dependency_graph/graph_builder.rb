module Dry
  module System
    module DependencyGraph
      class GraphBuilder
        def call(events)
          nodes = calculate_nodes(events)
          edges = calculate_edges(events, nodes)

          { nodes: nodes, edges: edges }
        end

      private

        def calculate_nodes(events)
          events[:registered_dependency].flat_map do |event|
            *node_parts, _node_name = event[:key].to_s.split('.')

            if node_parts.any?
              parent_keys = node_parts.map.with_index { |_keys, i| node_parts[0..i].join('.') }

              nodes = parent_keys.map.with_index do |name, i|
                parent = i.zero? ? nil : parent_keys[i - 1]
                { data: { id: name, label: name, parent: parent, weight: 100 } }
              end

              nodes + [{ data: { id: event[:class].name, label: event[:key].to_s, parent: node_parts.join('.'), weight: 50 } }]
            else
              [{ data: { id: event[:class].name, label: event[:key].to_s, weight: 50 } }]
            end
          end.uniq
        end

        def group_by_keys(nodes)
          nodes.group_by do |class_name, payload|
            scope = payload[:label].split('.').first
            scope == payload[:label] ? 'other' : scope
          end
        end

        def calculate_edges(events, nodes)
          events[:resolved_dependency].flat_map do |event|
            event[:dependency_map].map do |label, key|
              inject_class = nodes.find { |node| node[:data][:label] == key }
              { data: { target: event[:target_class].name, source: inject_class[:data][:id], label: label } }
            end
          end
        end
      end
    end
  end
end
