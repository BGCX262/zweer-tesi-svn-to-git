function [ARHR]=CalculateARHR10(tabella)
    n=size(tabella,1);
    
    pos1=length(find(tabella(:,3)==1));
    pos2=length(find(tabella(:,3)==2));
    pos3=length(find(tabella(:,3)==3));
    pos4=length(find(tabella(:,3)==4));
    pos5=length(find(tabella(:,3)==5));
    pos6=length(find(tabella(:,3)==6));
    pos7=length(find(tabella(:,3)==7));
    pos8=length(find(tabella(:,3)==8));
    pos9=length(find(tabella(:,3)==9));
    pos10=length(find(tabella(:,3)==10));
    
    ARHR=((pos1/1) +  (pos2/2) + (pos3/3) + (pos4/4) + (pos5/5) + (pos6/6) +  (pos7/7) + (pos8/8) + (pos9/9) + (pos10/10))/n;
    
end