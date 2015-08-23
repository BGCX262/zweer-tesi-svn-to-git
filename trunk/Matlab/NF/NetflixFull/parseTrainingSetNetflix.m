function [urm,userCache,userCacheBis] = parseTrainingSetNetflix(directoryPath)
% function [urm,userCache,userCacheBis] = parseTrainingSetNetflix(directoryPath)
% 

SLASH='/';
DELIMITER = ',';

allocatedurmSIZE=[480189,17770];
maxIDuser = 2649429;

D = dir ([directoryPath,SLASH,'mv_*.txt']);
numFilesToParse=length(D);
urm=sparse(allocatedurmSIZE);
urmTmp=sparse(maxIDuser,allocatedurmSIZE(2));
usersID=zeros(maxIDuser,1);

tic;
for i=1:numFilesToParse
    fileName = D(i).name;    
    itemID = str2num(fileName(4:end-4));
    fid = fopen([directoryPath,SLASH,fileName]);
    
    fline = fgetl(fid);
    if (fline(end)==':')
        if(str2num(fline(1:end-1))~=itemID)
            error ('ambiguous itemID...');
        end
    end
    
    tend=toc;
    perItemTime=(tend)/i;
    remainingTime=perItemTime*(numFilesToParse-i);
    disp([num2str(itemID),' - remainingTime=',num2str(round(remainingTime)),' sec']);    
    
    while 1
        fline = fgetl(fid);
        
        if ~ischar(fline),   break,   end
        
%{        
        splitted_indices = strfind(fline,DELIMITER);
        if (length(splitted_indices)~=2)
            error ('wrong line in parsed file...');
            continue;
        end
        userID=str2num(fline(1:splitted_indices(1)-1));
        rating=str2num(fline(splitted_indices(1)+1:splitted_indices(2)-1));
        %ratingDate=fline(splitted_indices(2)+1:end);
        urmTmp(userID,itemID)=rating;
        usersID(userID)=1;        
%}
        parsedVar = textscan(fid, '%n, %n, %*s');
        userIDs=parsedVar{1};
        ratings=parsedVar{2};
        
        tmpItem=zeros(size(urmTmp,1),1);
        tmpItem(userIDs)=ratings;
        urmTmp(:,itemID)=tmpItem;
        
        %urmTmp(userIDs,itemID)=ratings;
        usersID(userIDs)=1;
    end
    
    fclose(fid);
    
end

actualUsersID=find(usersID);
actualUsersNum=length(actualUsersID);
userCache=zeros(actualUsersNum,2);
userCache(:,1)=1:actualUsersNum;
userCache(:,2)=actualUsersID;
urm=urmTmp(actualUsersID,:);

userCacheBis=zeros(max(userCache(:,2)),1); tic, for i=1:size(userCache,1), userCacheBis(userCache(i,2))=i; if (mod(i,1000)==0), disp([num2str(i), ' - ', num2str((toc/i)*(size(userCache,1)-i))]); end; end


end