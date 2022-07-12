classdef RedBlackTree<handle
    % RedBlackTree implementation
    
    
    properties
        NiL
        root
    end
    
    methods
        function rbTree=RedBlackTree(keys)
            if ~isempty(keys)
                import Nodes.*
                rbTree.root=ColoredNode(keys(1));
               
                % root node is always black!!!
               rbTree.root.color=Colors.black;
               
               % NiL node is always black!!!
               rbTree.NiL=ColoredNode(NaN);
               rbTree.NiL.color=Colors.black;
               
               rbTree.NiL.left=rbTree.root;
               rbTree.NiL.right=rbTree.root;
               rbTree.root.parent=rbTree.NiL;
               rbTree.root.left=rbTree.NiL;
               rbTree.root.right=rbTree.NiL;
            end
            import Nodes.*
            if length(keys)>1
                for i=2:length(keys)
                    node=ColoredNode(keys(i));
                    rbTree.addNode(node);
                end
            end
 
        end
        function addNode(rbTree,node)
            import Nodes.*
            y=rbTree.NiL;
            x=rbTree.root;
            while x~=rbTree.NiL
               y=x;
               if node.data<x.data
                  x=x.left;
               elseif node.data>x.data
                   x=x.right;
               else
                   return
               end
               
            end
            node.parent=y;
            if y==rbTree.NiL
                rbTree.root=node;
            else
                if node.data<y.data
                    y.left=node;
                elseif node.data>y.data
                    y.right=node;
                
                else
                    return
                end
            end
            
            %insert node into tree
            node.left=rbTree.NiL;
            node.right=rbTree.NiL;
            node.color=Colors.red;
            
            %call the fixup method for setting the tree right
            rbInsertFixup(rbTree,node);
        end
        
        
        function y=rbDeleteNode(rbTree,node)
            import Nodes.*
            if node.left==rbTree.NiL || node.right==rbTree.NiL
                y=node;
            else
                y=treeSuccessor(rbTree,node);
                
            end
            
            if y.left==rbTree.NiL
                x=y.left;
            else
                x=y.right;
            end
            
            x.parent=y.parent;
            
            if y.parent==rbTree.NiL
                rbTree.root=x;
            else
                if y==y.parent.left
                    y.parent.left=x;
                else
                    y.parent.right=x;
                end
            end
            
            if y==node
                node.data=y.data;
            end
            
            if y.color==Colors.black
                rbDeleteFixup(rbTree,x);
            end
            
                    
        end
        % method for searching for k- key in the tree.
        function node=treeSearch(rbTree,node,k)

            while node~=rbTree.NiL && k~=node.data
                if k<node.data
                    node=node.left;
                else
                    node=node.right;
                end
            end
                
        end
    
    
        function plot(rbTree)
                        
            f=figure;
            axes('Parent',f,'XLim',[0 1],'YLim',[0 1],'XTick',[],'YTick',[]);
            grid on;
            ploting(rbTree,rbTree.root,0,1,0.9);
        end
        
        function num=maxInTree(rbTree,node)
            while node.right~=rbTree.NiL
                node=node.right;
            end
            num=node.data;
        end
        function num=minInTree(rbTree,node)
            while node.left~=rbTree.NiL
                node=node.left;
            end
            num=node.data;
        end
        
        function num=numberOfNodes(rbTree,node)
            num=countNodes(rbTree,node,0);
        end
    end
    methods (Access=private)
        
        % insertaion helper function
        function rbInsertFixup(rbTree,node)
            import Nodes.*
            while node.parent.color==Colors.red
                if node.parent==node.parent.parent.left
                    y=node.parent.parent.right;
                    if y.color==Colors.red
                        node.parent.color=Colors.black;
                        y.color=Colors.black;
                        node.parent.parent.color=Colors.red;
                        node=node.parent.parent;
                    else
                        if node==node.parent.right
                            node=node.parent;
                            leftRotate(rbTree,node);
                        end
                        node.parent.color=Colors.black;
                        node.parent.parent.color=Colors.red;
                        rightRotate(rbTree,node.parent.parent);
                    end
                else
                    y=node.parent.parent.left;
                    if y.color==Colors.red
                        node.parent.color=Colors.black;
                        y.color=Colors.black;
                        node.parent.parent.color=Colors.red;
                        node=node.parent.parent;
                    else
                        if node==node.parent.left
                            node=node.parent;
                            rightRotate(rbTree,node);
                        end
                        node.parent.color=Colors.black;
                        node.parent.parent.color=Colors.red;
                        leftRotate(rbTree,node.parent.parent);
                    end
                            
                end
            end
            rbTree.root.color=Colors.black;
        end
        
        % rotate left helper fuction
        function leftRotate(rbTree,node)
            y=node.right;
            node.right=y.left;
            if y.left~=rbTree.NiL
                y.left.parent=node;
            end
            y.parent=node.parent;
            if node.parent==rbTree.NiL
                rbTree.root=y;
            else
                if node==node.parent.left
                    node.parent.left=y;
                else
                    node.parent.right=y;
                end
                    
            end
            y.left=node;
            node.parent=y;
        end
        
        % rotate right helper function
        function rightRotate(rbTree,node)
            y=node.left;
            node.left=y.right;
            if y.right~=rbTree.NiL
                y.right.parent=node;
            end
            y.parent=node.parent;
            if node.parent==rbTree.NiL
                rbTree.root=y;
            else
                if node==node.parent.right
                    node.parent.right=y;
                else
                    node.parent.left=y;
                end
                    
            end
            y.right=node;
            node.parent=y;
        end
        
        
        % deletion helper function
        function rbDeleteFixup(rbTree,node)
            while node~=rbTree.root && node.color==Colors.black
                if node==node.parent.left
                    w=node.parent.right;
                    if w.color==Colors.red
                        w.color=Colors.black;
                        node.parent.color=Colors.red;
                        leftRotate(rbTree,node.parent);
                        w=node.parent.right;
                    end
                    
                    if w.left.color==Colors.black && w.right.color==Colors.black
                        w.color=Colors.red;
                        node=node.parent;
                    else
                        if w.right.color==Colors.black
                            w.left.color=Colors.black;
                            w.color=Colors.red;
                            rightRotate(rbTree,w);
                            w=node.parent.right;
                        end
                        w.color=node.parent.color;
                        node.parent.color=Colors.black;
                        w.right.color=Colors.black;
                        leftRotate(rbTree,node.parent);
                        node=rbTree.root;
                    end
                else
                    w=node.parent.left;
                    if w.color==Colors.red
                        w.color=Colors.black;
                        node.parent.color=Colors.red;
                        rightRotate(rbTree,node.parent);
                        w=node.parent.left;
                    end
                    
                    if w.right.color==Colors.black && w.left.color==Colors.black
                        w.color=Colors.red;
                        node=node.parent;
                    else
                        if w.left.color==Colors.black
                            w.rightt.color=Colors.black;
                            w.color=Colors.red;
                            leftRotate(rbTree,w);
                            w=node.parent.left;
                        end
                        w.color=node.parent.color;
                        node.parent.color=Colors.black;
                        w.left.color=Colors.black;
                        rightRotate(rbTree,node.parent);
                        node=rbTree.root;
                    end
                end
            end
            node.color=Colors.black;
        end
        % successor find helper method
        function successor=treeSuccessor(rbTree,node)
            if node.right~=rbTree.NiL
                successor=treeMinimum(rbTree,node.right);
                return
            end
            y=node.parent;
            while y~=rbTree.NiL && node==y.right
                node=y;
                y=y.parent;
            end
            successor=y;
        end
        
        % minimum in tree helper function
        function min=treeMinimum(rbTree,node)
            while node.left~=rbTree.NiL
                node=node.left;
            end
            min=node;
        end


        function ploting(rbTree,node,x1,x2,y)
            import Nodes.*
            if ~isempty(node)&& node~=rbTree.NiL
               x=mean([x1 x2]);
               ploting(rbTree,node.left,x1,x,y-0.1);
               ploting(rbTree,node.right,x,x2,y-0.1);
               
               if node.color==Colors.red
                   color=[1 0 0];
               else
                   color=[0 0 0];
               end
               patch([x-0.015,x+0.015,x+0.015,x-0.015],[y+0.015,y+0.015,y-0.015,y-0.015],...
                   ones(1,4),'FaceColor',color);
               
               text(x-0.005,y,num2str(node.data),'FontWeight','bold','Color',[1 1 1]);
               
               try
                   if node==node.parent.left
                       l=line([x x2],[y y+0.1],'Color',[1 0 0]);
                   end
                   if node==node.parent.right
                       l=line([x x1],[y y+0.1],'Color',[0 0 1]);
                   end
                   uistack(l,'bottom') 
               catch
                   return
               end
              
               
           end
        end
       
        function numOfNodes=countNodes(rbTree,node,numOfNodes)
             if node~=rbTree.NiL
               numOfNodes=numOfNodes+1;
               numOfNodes=countNodes(rbTree,node.left,numOfNodes);
               numOfNodes=countNodes(rbTree,node.right,numOfNodes);
             end
        end
    end
    
    % get/set methods
    methods
        % get root method
        function root=get.root(rbTree)
           root=rbTree.root; 
        end
        % set root method
        function set.root(rbTree,root)
            rbTree.root=root;
        end
        %getNiL method
        function nil=get.NiL(rbTree)
            nil=rbTree.NiL;
        end
        function set.NiL(rbTree,nil)
            rbTree.NiL=nil;
        end
    end
    
end

