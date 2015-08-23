function [tab]=createTableEvaluation(list,resh,listapop)
    tab=[];
    for i=1:length(list)
        tab(i,1)=list(i).codUtente;
        itemEvaluation=list(i).itemEvaluation;
        tab(i,2)=itemEvaluation;
        if (resh==0)
            lista=list(i).nuovalista;
        else
            lista=list(i).listaAnti;
        end
        [h,m]=sort(-lista);
	    posizione=find(m==itemEvaluation);
        tab(i,3)=posizione; 
        tab(i,4)=list(i).popolare; 
        bool=find(listapop==list(i).itemtolto);
        tab(i,5)=length(bool);
    end
end