function [urmcompact] = compactURM(urm, direction)
%function [urmcompact] = compactURM(urm, direction)
%
% urm = matrix to compact
% direction = 1 compact rows (default), 2 compact cols, 3 compact both

if (exist('direction')==0)
    direction=1;
end

if (direction==1 || direction==3)
    sumRows=sum(urm,2);
    [i,j]=find(sumRows>0);
    urmcompact=urm(i,:);
    urm=urmcompact;
end
if (direction==2 || direction==3)
    sumCols=sum(urm,1);
    [i,j]=find(sumCols>0);
    urmcompact=urm(:,j);    
end
end