classdef FullNode<Nodes.Node
    % FullNode is a node that expends on the basic node type
    % properties inherited from Node Class:
    % left- left son
    % right- right son
    %
    % Additional properties:
    % parent- parent of the current node
    
    properties (Access=public)
        parent
    end
    
    methods
        function fullNode=FullNode(newData)
           % call superClass constructor
           
           fullNode=fullNode@Nodes.Node(newData);
        end
        % set and get methods for parent property.
        function node=set.parent(node,parent)
            node.parent=parent;
        end
        
        function node=get.parent(node)
            node=node.parent;
        end
    end
    
end

