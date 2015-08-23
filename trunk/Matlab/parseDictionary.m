function [stemRow,isSinonim,stem,isStem,lang,stemType] = parseDictionary(filePath)

%fid = fopen('D:\Documenti\Other\neptuny\swisscom\LSA2\20081119180423\itemtitle.dat');
fid = fopen(filePath);
DELIMITER = '|';
INITIAL_SIZE=25000;

h = waitbar(0,'Please wait...');

i=1;
stemRow=zeros(INITIAL_SIZE,1);
isSinonim=zeros(INITIAL_SIZE,1);
stem='';
isStem=zeros(INITIAL_SIZE,1);
lang='';
stemType='';

while 1
    fline = fgetl(fid);
    if ~ischar(fline),   break,   end
    splitted_indices = strfind(fline,DELIMITER);
    if (length(splitted_indices)~=5) 
        display('errore');
        i
    end
    stemRow(i)= str2num(fline(1:splitted_indices(1)-1))+1;
    isSinonim(i)= str2num(fline(splitted_indices(1)+1:splitted_indices(2)-1));
    stem = strvcat(stem, fline(splitted_indices(2)+1:splitted_indices(3)-1));
    isStem(i) = str2num(fline(splitted_indices(3)+1:splitted_indices(4)-1));
    lang = strvcat(lang, fline(splitted_indices(4)+1:splitted_indices(5)-1));
    stemType = strvcat(stemType, fline(splitted_indices(5)+1:end));
    i=i+1;
    if mod(i,1000)==0
        waitbar(i/INITIAL_SIZE,h,num2str(i));
        i
    end
end

if i<=INITIAL_SIZE
    stemRow=stemRow(1:i-1,1);
    isSinonim=isSinonim(1:i-1,1);
    isStem=isStem(1:i-1,1);
end

fclose(fid);
close(h);

end