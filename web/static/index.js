function buildGraph(data) {
  const minimap = new Minimap({
    size: [200, 200],
    className: 'minimap',
  });

  var width = document.getElementById('graph').scrollWidth;
  var height = document.getElementById('graph').scrollHeight || 500;

  var graph = new G6.Graph({
    plugins: [minimap],
    container: document.getElementById('graph'),
    width: width, // Number, required, the width of the graph
    height: height, // Number, required, the height of the graph

    fitView: true,

    layout: {
      type: 'dagre',
      rankdir: 'BT',
      align: 'DL',
      nodesep: 100,
      ranksep: 200,
    },

    modes: {
      default: [
        'drag-node', 'drag-group', 'collapse-expand-group', 'drag-canvas', 'zoom-canvas'
      ]
    },

    nodeStateStyles: {
      active: {
        fill: "#9EC9FF",
        opacity: 1
      },
      inactive: {
        fill: "#d9e9fd",
        opacity: 1
      }
    },

    edgeStateStyles: {
      active: {
        stroke: "#e2e2e2"
      },
      inactive: {
        stroke: "#f5f2f2"
      }
    },

    defaultNode: {
      shape: "rect",
      size: [200, 50],
      color: "#5B8FF9",
      style: {
        fill: "#9EC9FF",
        lineWidth: 2
      },
      labelCfg: {
        style: {
          fill: "#000",
          fontSize: 16
        }
      },
      label: 'node-label',
    },

    defaultEdge: {
      style: {
        stroke: "#a2a2a2",
        endArrow: true,
      },
      labelCfg: {
        style: {
          fill: "#828282",
          fontSize: 12
        }
      },
    },

    groupType: 'rect',
    groupStyle: {
      default: {
        minDis: 100,
        maxDis: 150,
      },
      hover: {},
      collapse: {},
    },
  });

  graph.data(data); // Load the data defined in Step 2
  graph.render(); // Render the graph
}
