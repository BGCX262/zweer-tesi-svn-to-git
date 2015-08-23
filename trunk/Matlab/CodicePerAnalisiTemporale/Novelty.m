function [nov,mat]=Novelty(mat,rec,numprof)

prof=mat(numprof,:);
pres=sum(prof(rec));
nov=10-pres;
mat(numprof,rec)=1;

end