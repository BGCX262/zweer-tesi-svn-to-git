function [lista_gap]=calculate_position_gap_perc(lista,listavecchia,listanuova)
% Funzione per il calcolo del gap di posizione percentuale
lista_gap=[];
for n=1:length(lista)
    [i,j]=sort(-listavecchia);
    [h,k]=sort(-listanuova);
    posold=find(j==lista(n));
    posnew=find(k==lista(n));
    if (posold==posnew)
        gap=0;
    else
        if (posold>posnew)
            gap=(posold-posnew)/posold;
        else
            gap=(posnew-posold)/posnew;
            gap=-gap;
        end
    end
    lista_gap(n)=gap;
end
lista_gap=lista_gap';
end