function [id_dist_id]=CosenoFallout(pathUrm,i,typeOfTest)

% carico i file contenenti le urm di train e di test. 
% Viene utilizzata la urm contenuta in Uespl (caso esplicito), o Ubin 
% (caso binario) per il train, e la matrice Uloo per il test, che è una 
% matrice ridotta rispetto a quella di train, infatti contiene degli 1 
% (caso binario) o un rating (caso esplicito) solo in corrispondenza dei 
% voti massimi per l'utente.

%carico la top dei film più visti perchè sfrutto l'informazione sulla
%popolarità per stabilire, tra più film con lo stesso valore di
%raccomandazione, quali sono i 5 più significativi
M=dir(strcat(pathUrm,'popolarita.mat'));
load(strcat(pathUrm,M.name));

if i==1
    M=dir(strcat(pathUrm,'DRcoshalf1BINbase.mat'));
    load(strcat(pathUrm,M.name));
    II = DRcoshalf1BINbase;
    clear DRcoshalf1BINbase;
    
    M=dir(strcat(pathUrm,'urmtrasp2half.mat'));
    load(strcat(pathUrm,M.name));
    urmTestTrasp = urmtrasp2half;
    clear urmtrasp2half;
    
    M=dir(strcat(pathUrm,'antiUleaveOO2perctrasp2half.mat'));
    load(strcat(pathUrm,M.name));
    urmTestLooTrasp = antiUleaveOOtrasp2half;
    clear antiUleaveOOtrasp2half;
    % urmTest è la parte che usiamo nel test per generare la
    % raccomandazione, urmTestLoo è la parte che usiamo nel test per
    % capire quali film mettere a zero
else
    M=dir(strcat(pathUrm,'DRcoshalf2BINbase.mat'));
    load(strcat(pathUrm,M.name));
    II = DRcoshalf2BINbase;
    clear DRcoshalf2BINbase;
    
    M=dir(strcat(pathUrm,'urmtrasp1half.mat'));
    load(strcat(pathUrm,M.name));
    urmTestTrasp = urmtrasp1half;
    clear urmtrasp1half;

    M=dir(strcat(pathUrm,'antiUleaveOO2perctrasp1half.mat'));
    load(strcat(pathUrm,M.name));
    urmTestLooTrasp = antiUleaveOOtrasp1half;
    clear antiUleaveOOtrasp1half;
end

id_dist_id = [];

% calcolo la raccomandazione per ogni singolo utente
for ii=1:size(urmTestTrasp,2)
    activeUser = urmTestTrasp(:,ii)';
    if length(find(activeUser))>=2
        itemNotZero = find(urmTestLooTrasp(:,ii));
        % calcolo la Leave One Out sugli utenti della 'urmTestLoo'
        % per tutti gli item di test faccio il test LOO e genero la
        % raccomandazione
        if isempty(itemNotZero)==0
            % se c'è almeno un item su cui fare il test
            for j=1:length(itemNotZero)
                temp=activeUser(itemNotZero(j));
                % imposto a 0 un elemento alla volta
                activeUser(itemNotZero(j)) = 0;
                % l'itemNotZero(j) e' l'item di test
                % calcolo le relazioni multiple con la somma
                activeUser=full(activeUser);
                rec=activeUser*II;
                indici=find(isnan(rec));
                rec(indici)=0;
                notZeros = find(activeUser);
                % metto a zero gli id corrispondenti ai film gia'
                % presenti nel profilo dell'utente attivo
                rec(notZeros)=-Inf;
                rec=full(rec);
                % ordino la lista di raccomandazione
                [value list] = sort(rec,'descend');                
                % controllo quali elementi di rec ordinati dal valore più
                % grande a quello più piccolo abbiano lo stesso valore
                % del quinto elemento tra quelli a valore maggiore
                ind=find(value==value(5));
                index=list(ind);
                % in ind ci sono gli indici dei film da controllare, ovvero
                % bisogna decidere quali n film raccomandare tra questi che
                % hanno lo stasso valore di similarità

                if (length(ind)>1)
                    controllare=zeros(1,size(urmTestTrasp,2));
                    controllare(index)=popolarita(index);
                    [g h]=sort(controllare,'descend');
                    numins=6-ind(1);
                    rec( h((numins+1):length(ind)) ) = rec( h((numins+1):length(ind)) )-0.001;
                    [value list] = sort(rec,'descend');
                end

                % riempio il vettore utilizzato per l'accuratezza
                pos = find(list == itemNotZero(j));
                activeUser(itemNotZero(j))=temp;
                % sulla terza colonna di id_dist_id devo mettere l'id
                % dell'utente rispetto all'intera matrice campione, non
                % rispetto alla sua metà
                if (isempty(pos)==0)
                    if i==1
                        idUtente = ii + size(urmTestTrasp,2);
                    else
                        idUtente = ii;
                    end
                    id_dist_id=[id_dist_id;itemNotZero(j) pos idUtente];
                end
            end
        end
    end
end
save(strcat(pathUrm,'test/',typeOfTest,num2str(i),'half.mat'),'id_dist_id');