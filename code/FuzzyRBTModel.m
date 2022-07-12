function [original,predito,naive, forestepsahead] = FuzzyRBTModel(Data, STEPSAHEAD)

close all; clc;format long;

y = Data;

U = [min(Data)*1 max(Data)*1];
Rg = max(U)-min(U);
SD = std(Data,1);N = length(Data);
W = Rg/(SD*N);
Lbound = min(Data)-W; Ubound = max(Data)+W;
U = [Lbound Ubound];
y1 = 1;
Xmid = (Lbound+Ubound)/2*y1;
Troot = Xmid;

[Dataaux,ia,ic] = unique(Data,'stable');
tree = TCARBtree(Dataaux);

a = size(tree);

cluster(1:a(1))=0;
cluster(1) = 1;

clear aux

for i=1:1:length(tree)
   if (tree(i,1)~=0) || (tree(i,3)~=0)
      aux=  [(tree(i,1)~=0) && (tree(i,3)~=0)
             (tree(i,1)~=0) && (tree(i,3)==0)
             (tree(i,1)==0) && (tree(i,3)~=0)
             (tree(i,1)==0) && (tree(i,3)==0)];

      switch find(aux==1)   
          case 1%both children different from 0
               diffleft = abs(tree(i,2)-tree(i,1));diffright = abs(tree(i,2)-tree(i,3));
               if (diffleft<=diffright)
                   cluster(find(tree(:,2)==tree(i,1),1))=cluster(i);%cluster(root.left) = cluster(root)
                   if (tree(find(tree(:,2)==tree(i,3)),1)~=0  || tree(find(tree(:,2)==tree(i,3)),3)~=0)%if cluster(root.right) has at least one child
                    cluster(find(tree(:,2)==tree(i,3),1))=max(cluster)+1;  
                   else
                    cluster(find(tree(:,2)==tree(i,3),1))=cluster(i);  
                   end
               elseif (diffleft>diffright)
                   cluster(find(tree(:,2)==tree(i,3),1))=cluster(i); 
                   if (tree(find(tree(:,2)==tree(i,1)),1)~=0  || tree(find(tree(:,2)==tree(i,1)),3)~=0)
                    cluster(find(tree(:,2)==tree(i,1),1))=max(cluster)+1;  
                   else
                    cluster(find(tree(:,2)==tree(i,1),1))=cluster(i);  
                   end
               end
          case 2
              cluster(find(tree(:,2)==tree(i,1),1))=cluster(i);
          case 3
              cluster(find(tree(:,2)==tree(i,3),1))=cluster(i);
          case 4%both children equals 0    

      end    
   end
      
end 

for i=1:1:max(cluster)
    c(i) = numel(find(cluster==i));
end
maxClusterElements = max(c);

Clusters = zeros(max(cluster),maxClusterElements+1);
a = size(Clusters);

for i=1:1:a(1)
    n(i) = numel(find(cluster==i));
    el = [tree(find(cluster==i),2)]';
    Clusters(i,:) = [i el zeros(1,maxClusterElements-n(i))];
    clusterCenters(i) = mean(el);
    clusterIntervals(i,:) = [min(el) max(el)]; 
end    

tester = zeros(length(Data),1);
for i=1:1:length(Data)
    for j=1:1:length(clusterCenters)
        if Data(i)>= clusterIntervals(j,1) && Data(i)<= clusterIntervals(j,2)
            A(i) = j;
            tester(i) = tester(i)+1;
        end
    end
end

maxPostRules = 0;
for i=1:1:max(A)
    el = (A(find(A(1:end-STEPSAHEAD)==i)+STEPSAHEAD));
    if maxPostRules<length(el)
        maxPostRules=length(el);
    end    
end

clear el n i

for i=1:1:max(A)
        el = (A(find(A(1:end-STEPSAHEAD)==i)+STEPSAHEAD));
        FRG(i,:)=[i el zeros(1,maxPostRules-length(el))];%a(2) = max number of elements in a cluster
   
end   

for i=STEPSAHEAD+1:1:length(A)
    aux=FRG(find(FRG(:,1)==A(i-STEPSAHEAD)),:);
    aux = aux(find(aux~=0));
    aux = aux(2:end);
    w = ([1:length(aux)])';
    fore(i) = (clusterCenters([aux]))*(w/sum(w));
end

forecast = fore;

last = FRG(find(FRG(:,1)==A(end)),:);
if(numel(find(A==A(end)))==1 && last(2)==0)
    display('Impossible predition for 1 step ahead out');
    display('of sample. Final Element of A is unique');
    display('and is alone in a cluster');
end

alfa = 0;
    last = FRG(find(FRG(:,1)==A(end-STEPSAHEAD+1)),:);
    if(numel(find(A(1:end-STEPSAHEAD+1)==A(end-STEPSAHEAD+1)))==1 && last(2)==0)
        forestepsahead = fore(end-STEPSAHEAD+1);
    else
        aux=FRG(find(FRG(:,1)==A(end-STEPSAHEAD+1)),:);
    
    aux = aux(find(aux~=0));
    aux = aux(2:end);
    w = ([1:length(aux)])';
    forefuzzy = mean(clusterCenters([aux]))*(w/sum(w));
   
    forestepsahead = mean(clusterCenters([aux]));
    end

clear n original predito naive
original = y(STEPSAHEAD+1:end);
%testedata = original;
naive = y(1:end-STEPSAHEAD);
predito = [fore(STEPSAHEAD+1:end)]';
%teste = predito;

end
