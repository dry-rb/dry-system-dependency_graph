module Dry
  module System
    module DependencyGraph
      class GraphBuilder
        def call(events)
          nodes = calculate_nodes(events)
          edges = calculate_edges(events, nodes)
          groups = calculate_groups(nodes)

          nodes_outside_container = (edges.map { |e| e[:target] } - nodes.map { |n| n[:id] }).map do |class_name|
            { id: class_name, label: class_name, shape: 'ellipse' }
          end.uniq

          nodes = nodes + nodes_outside_container

          { nodes: nodes, edges: edges, groups: groups }
        end

      private

        def calculate_nodes(events)
          events[:registered_dependency].map do |event|
            *node_parts, _node_name = event[:key].to_s.split('.')

            if node_parts.any?
              { id: event[:class].name, label: event[:key].to_s, groupId: node_parts.join('.'), weight: 50 }
            else
              { id: event[:class].name, label: event[:key].to_s }
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

              inject_class = nodes.find { |node| node[:label].to_s == key.to_s }
              { target: event[:target_class].name, source: inject_class[:id], label: label }
            end
          end
        end

        def calculate_groups(nodes)
          nodes.map { |node| node[:groupId] }.uniq.compact.flat_map do |group_name|
            group_parts = group_name.split('.')
            group_keys = group_parts.map.with_index { |_keys, i| group_parts[0..i].join('.') }

            group_keys.map.with_index do |name, i|
              title = { text: name, fontSize: 24, offsetY: 30, }

              if i.zero?
                { id: name, title: title  }
              else
                { id: name, title: title, parentId: group_keys[i - 1] }
              end
            end
          end.sort { |node1, node2| node2[:id].size <=> node1[:id].size }
        end
      end
    end
  end
end
