function [urmTS, ratings, lang, chan] = parseURM_langChan(filePath, userID_row, itemID_row, allocatedRows, dataParser, stopOnAllocatedRows)
% function [urmTS, ratings, lang, chan] = parseURM_langChan(filePath,
% userID_row, itemID_row, allocatedRows, dataParser, stopOnAllocatedRows)
%
% parse URM with timestamp (text file with 6 cols, userid|itemid|rating|language|channel|timestamp)
%
% PARAMETERS:
% filePath = path of urm text file
% allocatedRows = number of estimated rows (preallocated to speed up
% loading)
% dataParser = 'dd-mm-yyyy HH:MM:SS' oppure 'yyyy-nn-dd HH:MM:SS'
%
% OPTIONAL
% stopOnAllocatedRows = if it is present loading stops after allocatadRows

stopOn = false;
if (exist('stopOnAllocatedRows')~=0)
    stopOn = true;
end

    fid = fopen(filePath);
    DELIMITER = '|';

    urmTS=zeros(allocatedRows,3);
    lang=cell(allocatedRows,1);
    chan=cell(allocatedRows,1);
    ratings=zeros(allocatedRows,1);
    h = waitbar(0,'Please wait...');

    fgetl(fid);

    i=1;
    while (1 && ~(stopOn && i>allocatedRows))
        fline = fgetl(fid);
    %    if (i<174370)
    %        i=i+1;
    %        continue;
    %    end
        if ~ischar(fline),   break,   end
        splitted_indices = strfind(fline,DELIMITER);
        urmTS(i,1)= userID_row(find(userID_row(:,1)==str2num(fline(1:splitted_indices(1)-1))),2); %user
        urmTS(i,2)= itemID_row(find(itemID_row(:,1)==str2num(fline(splitted_indices(1)+1:splitted_indices(2)-1))),2); %item
        ratings(i)= str2num(fline(splitted_indices(2)+1:splitted_indices(3)-1)); %rating
        lang(i) = cellstr(fline(splitted_indices(3)+1:splitted_indices(4)-1));
        chan(i) = cellstr(fline(splitted_indices(4)+1:splitted_indices(5)-1));
        strdata = fline(splitted_indices(5)+1:end);
        if length(strdata)<12
            urmTS(i,3)= datenum(strdata,dataParser(1:10));
        else
            if length(strdata)>19 
                strdata=strdata(1:19);
            end
            urmTS(i,3)= datenum(strdata,dataParser);
        end
        i=i+1;
        if mod(i,5000)==0
            waitbar(i/allocatedRows,h,num2str(i))
		 u=toc;
		 display([num2str(i), '/', num2str(allocatedRows), ' - ', num2str(u)]);
            tic;
        end
    end
    fclose(fid);
    close(h);

end