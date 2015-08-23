function convertUrm2Text(urm,filename)
%function [urmtext] = convertUrm2Text(urm)

fid = fopen(filename,'w');
%urmtext='';
for i=1:size(urm,1)
%    urmtext=strvcat(urmtext,num2str(find(urm(i,:)>0)));
    fprintf(fid,'%s\n',num2str(find(urm(i,:)>0)));
    if (mod(i,100)==0) display(i); end;
end
fclose(fid);
end