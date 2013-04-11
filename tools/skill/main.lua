struct = require 'struct/struct'
require 'Graph'


function love.load()
    graph = Graph()
    graph:addNode(GraphNode('A', 1))
    graph:addNode(GraphNode('B', 1))
    graph:addNode(GraphNode('C', 1))
    graph:addNode(GraphNode('D', 1))
    graph:print()
    graph:addEdge('A', 'B')
    graph:addEdge('B', 'C')
    graph:addEdge('A', 'D')
    graph:print()
    graph:removeNode('C')
    graph:print()
    graph:removeEdge('A', 'D')
    graph:print()
end
