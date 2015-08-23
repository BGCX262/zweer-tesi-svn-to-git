function [lista_entranti,lista_uscenti,change]=check_inout(listavecchia,listanuova)
% Questa funzione prese due liste di raccomandazione complete restituisce la lista dei film che sono usciti dalla lista precedente e i film 
% che sono entrati nella lista attuale più un flag che indica se ci sono stati cambiamenti
% Se change=0 -> lunghezza (lista_entranti o lista_uscenti) = 0

k=1;
lista_entranti(k)=-1;
lista_uscenti(k)=-1;
change=0;
for i=1:length(listavecchia)
    actual=listavecchia(i);
    found=0;
    for j=1:length(listanuova)
        if(actual==listanuova(j)) 
            found=1;
            break;
        end
    end
    if (found==0)
        lista_uscenti(k)=actual;
        k=k+1;
    end
end
k=1;
for i=1:length(listanuova)
    actual=listanuova(i);
    found=0;
    for j=1:length(listavecchia)
        if(actual==listavecchia(j)) 
            found=1;
            break;
        end
    end
    if (found==0)
        lista_entranti(k)=actual;
        k=k+1;
    end
end
if(lista_uscenti(1)~=-1)
    change=1;
end
lista_entranti=lista_entranti';
lista_uscenti=lista_uscenti';
end