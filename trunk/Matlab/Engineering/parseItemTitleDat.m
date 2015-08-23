function [colnum,itemId,titles] = parseItemTitleDat(filePath)

%fid = fopen('D:\Documenti\Other\neptuny\swisscom\LSA2\20081119180423\itemtitle.dat');
fid = fopen(filePath);
DELIMITER = '|';

h = waitbar(0,'Please wait...');

titles='';
i=1;
colnum=zeros(1900,1);
itemId=zeros(1900,1);
while 1
    fline = fgetl(fid);
    if ~ischar(fline),   break,   end
    splitted_indices = strfind(fline,DELIMITER);
    if (length(splitted_indices)~=2) 
        display('errore');
        i
    end
    colnum(i)= str2num(fline(1:splitted_indices(1)-1))+1;
    itemId(i)= str2num(fline(splitted_indices(1)+1:splitted_indices(2)-1));
    titles = strvcat(titles, fline(splitted_indices(2)+1:end));
    i=i+1;
    if mod(i,10)==0
        waitbar(i/6270,h,num2str(i))
    end
end

fclose(fid);
close(h);

end