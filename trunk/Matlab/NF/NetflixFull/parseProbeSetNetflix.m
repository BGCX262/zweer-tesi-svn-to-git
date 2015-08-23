function [pairUserItem,urmProbeSet,pairUserRowItem] = parseProbeSetNetflix(filePath,userCache,urm)
% function [pairUserItem,urmProbeSet,pairUserRowItem] = parseProbeSetNetflix(filePath,userCache,urm)
% 
    fid = fopen(filePath);
    
    
    allocatedRows=3000000;

    pairUserItem=zeros(allocatedRows,2);
    pairUserRowItem=zeros(allocatedRows,2);
    ratings=zeros(allocatedRows,1);
    h = waitbar(0,'Please wait...');
    
    newUserCache=(size(userCache,2)==1);    

    i=0;
    while 1
        fline = fgetl(fid);
        if ~ischar(fline),   break,   end
        
        if (fline(end)==':')
            itemCol=str2num(fline(1:end-1));
            continue
        end
        userID = str2num(fline);
        if (newUserCache)
            userRow = userCache(userID);
        else
            userRow = userCache(find(userCache(:,2)==userID,1));
        end
        if (isempty(userRow))
           %display(['skipped userID=', num2str(userID)]);
           continue;
        end
        i=i+1;                
        pairUserItem(i,:)=[userID,itemCol];   
        pairUserRowItem(i,:)=[userRow,itemCol];
        ratings(i)=urm(userRow,itemCol);
        
      %  if(i==10000) break, end
        
        if mod(i,10000)==0
            waitbar(i/allocatedRows,h,num2str(i))
            disp(num2str(i));
        end
    end
    fclose(fid);
    pairUserItem=pairUserItem(1:i,:);
    pairUserRowItem=pairUserRowItem(1:i,:);
    ratings=ratings(1:i,:);

    %{ 
    indexes=pairUserRowItem(:,1)+(pairUserRowItem(:,2)-1).*size(urm,1);
    urmProbeSet=sparse(size(urm,1),size(urm,2));
    urmProbeSet(indexes)=urm(indexes);
    %}
    urmProbeSet=sparse(pairUserRowItem(:,1),pairUserRowItem(:,2),ratings);

    close(h);
end