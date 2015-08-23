function [A,B,C,D, Avod, ItemTitle_urmAC, ItemTitle_urmBD,itemsIndexes_IN_AC,itemsIndexes_IN_BD] = splitURMreplaytv (urmFull, urmVod, ItemTitle_urmFull, ItemTitle_urmVOD, usercacheFull, usercacheVOD, itemcacheFull, itemcacheVOD)
% [A,B,C,D, Avod, ItemTitle_urmAC, ItemTitle_urmBD,itemsIndexes_IN_AC,itemsIndexes_IN_BD] = splitURMreplaytv (urmFull, urmVOD, ItemTitle_urmFull, ItemTitle_urmVOD, usercacheFull, usercacheVOD, itemcacheFull, itemcacheVOD)
%
% Ad-hoc function for splitting URMfull (i.e., urm from VOD, replayTV and
% FastVCR) into the following submatrices:
%
% [A, B ; C, D]
% A = VOD users, VOD items
% B = VOD users, Non-VOD items
% C = Non-VOD users, VOD items
% D = Non-VOD users, Non-VOD items
%
% Avod = VOD users, VOD items (only VOD ratings)
%
% ItemTitle_urmAC, ItemTitle_urmBD = ItemTitle of VOD and non-VOD items,
% respectively
%
% itemsIndexes_IN_AC,itemsIndexes_IN_BD = indexes of VOD and non-VOD items,
% respectively, referred to columns of urmFull
%
% esempio: [A,B,C,D, Avod, ItemTitle_urmAC, ItemTitle_urmBD, itemsIndexes_IN_AC, itemsIndexes_IN_BD] =
% splitURMreplaytv (urmFull, urmVod, ItemTitle_urmFull, ItemTitle_urmVOD, usercacheURMFull, usercacheURMvod, itemCacheURMfull, itemCacheURMVod)

%AB=sparse(size(urmVod,1),size(urmFull,2));
%CD=sparse(size(urmFull,1),size(urmFull,2));
%Avod=sparse(size(urmVod,1),size(urmFull,2));
indexAB=1;
indexCD=1;
vodUsersIndexes=zeros(size(urmVod,1),1);
usersIndexes_IN_AB=zeros(size(urmVod,1),1);
usersIndexes_IN_CD=zeros(size(urmFull,1),1);
h = waitbar(0,'Please wait...');
tic
for u=1:size(urmFull,1)
   userID= usercacheFull(u,1);
   [x]=find(usercacheVOD(:,1)==userID);
   if (~isempty(x))
       usersIndexes_IN_AB(indexAB)=u;
       %AB(indexAB,:)=urmFull(u,:);        
       vodUsersIndexes(indexAB)=x;
       indexAB=indexAB+1;
   else
       usersIndexes_IN_CD(indexCD)=u;
       %CD(indexCD,:)=urmFull(u,:);
       indexCD=indexCD+1;
   end
   if (mod(u,1000)==0) 
       toc
       waitbar(u/size(urmFull,1),h,num2str(u));
       display(num2str(u));
       tic
   end
end
close(h);
%AB=AB(1:indexAB-1,:);
usersIndexes_IN_AB=usersIndexes_IN_AB(1:indexAB-1);
AB = urmFull(usersIndexes_IN_AB,:);
%CD=CD(1:indexCD-1,:);
usersIndexes_IN_CD=usersIndexes_IN_CD(1:indexCD-1);
CD = urmFull(usersIndexes_IN_CD,:);
vodUsersIndexes=vodUsersIndexes(1:indexAB-1);

A=sparse(size(AB,1),size(urmVod,2));
B=sparse(size(AB,1),size(urmFull,1));
C=sparse(size(CD,1),size(urmVod,2));
D=sparse(size(CD,1),size(urmFull,1));

indexAC=1;
indexBD=1;
ItemTitle_urmAC=char(size(urmVod,2),size(ItemTitle_urmFull,2));
ItemTitle_urmBD=char(size(urmFull,2),size(ItemTitle_urmFull,2));
vodItemsIndexes=zeros(1,size(urmVod,2));
itemsIndexes_IN_AC=zeros(size(urmVod,2),1);
itemsIndexes_IN_BD=zeros(size(urmFull,2),1);
h = waitbar(0,'Please wait...');
tic
for i=1:size(urmFull,2)
   itemID= itemcacheFull(i,1);
   [y]=find(itemcacheVOD(:,1)==itemID);
   if (~isempty(y))
       A(:,indexAC)=AB(:,i);
       C(:,indexAC)=CD(:,i);    
       itemsIndexes_IN_AC(indexAC)=i;
       ItemTitle_urmAC(indexAC,1:length(ItemTitle_urmFull(i,:)))=ItemTitle_urmFull(i,:);
       if (~strcmp(ItemTitle_urmFull(i,1:length(ItemTitle_urmVOD(y,:))),ItemTitle_urmVOD(y,:)))
           display (['Incongruenza ItemTitle... itemID:', itemID]);
       end
       vodItemsIndexes(indexAC)=y;
       indexAC=indexAC+1;
   else
       B(:,indexBD)=AB(:,i);
       D(:,indexBD)=CD(:,i);  
       itemsIndexes_IN_BD(indexBD)=i;
       ItemTitle_urmBD(indexBD,1:length(ItemTitle_urmFull(i,:)))=ItemTitle_urmFull(i,:);
       indexBD=indexBD+1;       
   end
   if (mod(i,100)==0) 
       toc
       waitbar(i/size(urmFull,2),h,num2str(i));
       display(num2str(i));
       tic
   end
end
close(h);
itemsIndexes_IN_AC=itemsIndexes_IN_AC(1:indexAC-1);
itemsIndexes_IN_BD=itemsIndexes_IN_BD(1:indexBD-1);
vodItemsIndexes=vodItemsIndexes(1:indexAC-1);
ItemTitle_urmBD=ItemTitle_urmBD(1:indexBD-1,:);
A=A(:,1:indexAC-1);
C=C(:,1:indexAC-1);
B=B(:,1:indexBD-1);
D=D(:,1:indexBD-1);
Avod=urmVod(vodUsersIndexes,vodItemsIndexes);

end