classdef ColoredNode<Nodes.FullNode
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        color
    end
   
    
    methods
        function node=ColoredNode(newData)
            
            node=node@Nodes.FullNode(newData);
        end
        % set and get methods for color property.
        function node=set.color(node,color)
            node.color=color;
        end
        
        function color=get.color(node)
            color=node.color;
        end
    end
    
end

