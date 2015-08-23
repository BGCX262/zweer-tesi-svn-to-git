function [final,finalTop,finalNoTop]=accuracy(path,nomeAlg,nomeTop,topIfUnder,racc,utMin,utMax,ls)
% 'path' è il path dove trovare i file dell'algoritmo e della top
% 'nomeAlg' è il nome del file riguardante l'algoritmo utilizzato
% 'nomeTop' è il nome del file in cui è contenuta la top di tutti i film
% 'topIfUnder' è il numero di film che vogliamo considerare nella top rating,
% ad es.: topIfUnder=10 vuol dire che consideriamo i primi 10 film più visti
% 'racc' è il valore che ci serve per calcolare l'accuratezza, ed è uguale al
% numero di film raccomandati nella lista di raccomandazione
% 'utMin' e 'utMax' servono per rappresentare le classi di visioni per utente,
% ad esempio utMin=2 e utMax=10 vuol dire riferirsi agli utenti che han
% visto tra i 2 e i 10 film
% 'ls' è un parametro che serve solo per SVD e rappresenta la latent size, se
% si usa DR mettere 1 come valore di ls


final=[];
finalTop=[];
finalNoTop=[];

% carico il file contenente la top di tutti i film
M=dir (strcat(path,nomeTop,'.mat'));
load (strcat(path,M.name));

% preferisco lavorare con un vettore colonna...
topRatedAll=topRatedAll';
[r,c]= size(topRatedAll);

% carico il vettore riga lungo 47798, contenente il numero di visioni di
% ogni utente
M=dir (strcat(path,'visioni_utente.mat'));
load (strcat(path,M.name));

indiciUtentiInprofilo=find(visioni_utente>=utMin & visioni_utente<utMax);
id_film_inprofilo=0;
id_film_inprofiloOK=0;
id_film_top=0;
id_film_notop=0;
id_film_topOK=0;
id_film_notopOK=0;
topPrimiK=topRatedAll(1:topIfUnder);
%topUltimiK=topRatedAll((topIfUnder+1):end);

for t=1:length(ls)
    % se l'algoritmo utilizzato non è SVD
    if length(ls)==1
        D=dir (strcat(path,nomeAlg,'.mat'));
    % se l'algoritmo utilizzato è SVD
    else
        D=dir (strcat(path,nomeAlg,num2str(ls(t)),'.mat'));
    end
    load (strcat(path,D.name));
    
    for j=1:size(id_dist_id,1)
        if isempty(find(indiciUtentiInprofilo==id_dist_id(j,3), 1))==0
            id_film_inprofilo=id_film_inprofilo+1;
            if isempty(find(topPrimiK==id_dist_id(j,1), 1))==0
                id_film_top=id_film_top+1;
                if (id_dist_id(j,2)<=racc)
                    id_film_topOK=id_film_topOK+1;
                    id_film_inprofiloOK=id_film_inprofiloOK+1;
                end
            else
                id_film_notop=id_film_notop+1;
                if (id_dist_id(j,2)<=racc)
                    id_film_notopOK=id_film_notopOK+1;
                    id_film_inprofiloOK=id_film_inprofiloOK+1;
                end
            end  
        end
    end
    final = [final; id_film_inprofiloOK/id_film_inprofilo ls(t)];
    finalNoTop = [finalNoTop; id_film_notopOK/id_film_notop ls(t)];
    finalTop = [finalTop; id_film_topOK/id_film_top ls(t)];
    id_film_inprofilo=0;
    id_film_inprofiloOK=0;
    id_film_top=0;
    id_film_notop=0;
    id_film_topOK=0;
    id_film_notopOK=0;
    actualLatentSize=ls(t)
end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        