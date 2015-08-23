function [EPR]= CalculateEPR(tabella,nfilms);
    rankperc=(tabella(:,3)-1)/(nfilms-1);
    rankperc=rankperc*100;
    dim=size(tabella);
    
    EPR=(sum(rankperc))/dim(1);
end