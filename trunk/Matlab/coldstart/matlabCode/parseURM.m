fid = fopen('urm.txt');
DELIMITER = '|';

minRowsToParse=2500000;


urm=full(sparse(minRowsToParse,3));
h = waitbar(0,'Please wait...');

fgetl(fid);

i=1;
while 1
    fline = fgetl(fid);
%    if (i<890000)
%        i=i+1;
%        continue;
%    end
    if ~ischar(fline),   break,   end
    splitted_indices = strfind(fline,DELIMITER);
    urm(i,1)= userID_row(find(userID_row(:,1)==str2num(fline(1:splitted_indices(1)-1))),2);
    urm(i,2)= itemID_row(find(itemID_row(:,1)==str2num(fline(splitted_indices(1)+1:splitted_indices(2)-1))),2);
    strdata = fline(splitted_indices(2)+1:end);
    if length(strdata)<12
        urm(i,3)= datenum(strdata,'yyyy-mm-dd');
    else
        urm(i,3)= datenum(strdata,'yyyy-mm-dd HH:MM:SS');
    end
    i=i+1;
    if mod(i,5000)==0
	  i
        waitbar(i/minRowsToParse,h,num2str(i))
    end
end
fclose(fid);