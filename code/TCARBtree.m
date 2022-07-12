function rbTree = TCARBtree(Datax)

%Tree Construction Algorithm for red-black tree and its matrix form
   
    Data = Datax;

    rbTreeStruct=RedBlackTree(Data);

    for k=1:1:length(Data)
        node=treeSearch(rbTreeStruct,rbTreeStruct.root,Data(k));
        rbTree(k,:) = [node.left.data node.data node.right.data];
    end
    rbTree(find(isnan(rbTree)))=0;
    
    root = rbTreeStruct.root.data;
    
    i=1;
    treematrix(1,:) = [rbTreeStruct.root.left.data rbTreeStruct.root.data rbTreeStruct.root.right.data];
    node=treeSearch(rbTreeStruct,rbTreeStruct.root,root);
    while i~=size(rbTree,1)
        if ~isnan(node.left.data)
            i=i+1;
            treematrix(i,:) = [node.left.left.data node.left.data node.left.right.data];
        end
        if ~isnan(node.right.data)
            i = i+1;
            treematrix(i,:) = [node.right.left.data node.right.data node.right.right.data];
        end
        node = treeSearch(rbTreeStruct,rbTreeStruct.root,treematrix(find(treematrix(:,2)==node.data)+1,2));
    end
    
    rbTree = treematrix;
    rbTree(find(isnan(treematrix)))=0;
    
end










