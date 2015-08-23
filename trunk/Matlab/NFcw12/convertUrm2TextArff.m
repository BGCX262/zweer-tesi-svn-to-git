function convertUrm2TextArff(urm,filename,titles)

fid = fopen(filename,'w');

fprintf(fid,'@relation urm\n');
if (exist('titles')==0)
    for i=1:size(urm,2)
        fprintf(fid,'@attribute item%d {POS,NEG}\n',i);
    end
else
    for i=1:size(urm,2)
        title=char(titles(i));
        title(strfind(title,' '))='_';
        title(strfind(title,'"'))='';
        title(strfind(title,','))='_';
        fprintf(fid,'@attribute %s(%d) {POS,NEG}\n',title,i);
    end   
end

fprintf(fid,'\n@data\n\n');

for i=1:size(urm,1)
    for j=1:size(urm,2)
        elem=urm(i,j);
        if (elem>0) 
            %s=num2str(urm(i,j));
            s='POS';
        elseif (elem<0)
            s='NEG';
        else
            s='?';
        end
        if (j<size(urm,2))
            s=strcat(s,',');
        end
        fprintf(fid,'%s',s);
    end
%    fprintf(fid,'%s\n',num2str(find(urm(i,:)>0)));
    if (i<size(urm,1))
       fprintf(fid,'\n'); 
    end
    if (mod(i,100)==0) display(i); end;
end
fclose(fid);
end