function [lista_gap]=calculate_position_gap (lista,listavecchia,listanuova)
% Funzione per il calcolo del gap di posizione assoluta

for n=1:length(lista)
    [i,j]=sort(-listavecchia);
    [h,k]=sort(-listanuova);
    posold=find(j==lista(n));
    posnew=find(k==lista(n));
    gap=posold-posnew;
    lista_gap(n)=gap;
end
lista_gap=lista_gap';
end