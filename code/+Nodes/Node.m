classdef Node<handle
    % Node class for doubly linked lists or binary trees
    % inherits from handle class
    %
    % properties:
    % data- data associated with this node
    % left- left son
    % right- right son
    
    properties (Access=public)
        data
        left
        right
        
    end
    
    methods
        % constructor method
        function node=Node(newData)
            
            node.data=newData;
        end
        % set and get methods.
        function set.left(node,Left)
            node.left=Left;
        end
        
        function node=get.left(node)
            node=node.left;
        end
        
        function set.data(node,newData)
            node.data=newData;
        end
        
        function value=get.data(node)
            value=node.data;
        end
        
        function set.right(node,Right)
            node.right=Right;
        end
        
        function node=get.right(node)
            node=node.right;
        end
            
    end
end


