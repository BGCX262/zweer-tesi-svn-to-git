function [adaptedMatrix] = prepareURMxLSA(itemId,urm,urmItemcacheFileName,direction, icmModel)
% function [urmAdapted] =
% prepareURMxLSA(itemId,urm,urmItemcacheFileName,direction)
%
% optional attributes:
% direction = 1 if URM is added ICM surplus-column (default value)
%           = 2 if ICM is removed ICM surplus-columns
% icmModel = used if direction = 2

display ('WARNING: use prepareURMxLSAnew');

if (exist('direction')==0)
    direction = 1;
elseif (direction ==2 & exist('icmModel')==0)
    display ('missing icmModel.. required!');
	return;
end

itemcache = parseItemCache(urmItemcacheFileName);

if (direction==1)

    adaptedMatrix=sparse(size(urm,1),length(itemId));

    itemMapping=zeros(length(itemId),1);
    for i=1:size(urm,2)
       tmp=find(itemcache(:,2)==i);
       itemIdUrm = itemcache(tmp,1);
       itemMapping(i)=find(itemId==itemIdUrm); % in itemMapping(i) c'è la colonna corrispondente nella matrice ICM 
       adaptedMatrix(:,itemMapping(i))=urm(:,i);
    end
elseif (direction==2)
    
    adaptedMatrix=sparse(size(icmModel,1),size(urm,2));

    itemMapping=zeros(size(urm,2),1);
    for i=1:size(urm,2)
       tmp=find(itemcache(:,2)==i);
       itemIdUrm = itemcache(tmp,1);
       itemMapping(i)=find(itemId==itemIdUrm); % in itemMapping(i) c'è la colonna corrispondente nella matrice ICM 
       
       adaptedMatrix(:,i)=icmModel(:,itemMapping(i));
    end
end

end