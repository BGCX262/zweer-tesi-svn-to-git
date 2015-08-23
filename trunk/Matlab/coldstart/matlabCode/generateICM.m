function [icm] = generateICM(itemIDX_urm, icmFile)
DELIMITER = '|';

fidItemIDX = fopen(icmFile);
flineIDX = fgetl(fidItemIDX);
itemcache=sparse(10000000,1);
while 1
    flineIDX = fgetl(fidItemIDX);
    if ~ischar(flineIDX),   break,   end
    splitted_indices = strfind(flineIDX,DELIMITER);
    iditem = str2num(flineIDX(1:splitted_indices(1)-1))+1;
    rowNum = str2num(flineIDX(splitted_indices(1)+1:splitted_indices(2)-1));
    
    itemcache(iditem)=rowNum;
    
end
fclose(fidItemIDX);

fidICM = fopen(icmFile);
flineICM = fgetl(fidICM);

h = waitbar(0,'Please wait...');

i=1;

icm=sparse(100,100);
while 1
    flineICM = fgetl(fidICM);
    if ~ischar(flineICM),   break,   end
    splitted_indices = strfind(flineICM,DELIMITER);
    idstem = str2num(flineICM(1:splitted_indices(1)-1))+1;
    iditem = str2num(flineICM(splitted_indices(1)+1:splitted_indices(2)-1));
    weight = str2num(flineICM(splitted_indices(1)+1:splitted_indices(2)-1));
    
    if (itemcache(iditem)~=0) 
        icm(idstem,itemcache(iditem))=weight;
    else
        display(['item ',num2str(iditem),' not found']);
    end
        
    i=i+1;
    if mod(i,1000)==0
        waitbar(i/55000,h,num2str(i));
        i
    end
end

fclose(fidICM);
close(h);

end