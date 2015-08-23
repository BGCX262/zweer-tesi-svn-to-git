function [soglia,app,c,d,cluster,umin,umax,numC,uNoC]=calcolaSogliaRoby(cosRelation,cMin,cMax,uMin,uMax,noMin,noMax)
% cmin indica il minimo numero di cluster
% cmax indica il massimo numero di cluster
% uMin indica il numero minimo di utenti per ogni cluster
% uMax indica il numero massimo di utenti per cluster
% noMin indica il numero minimo di utenti non clusterizzati
% noMax indica il numero massimo di utenti non clusterizzati
% s indica la soglia da cui l'algoritmo inizia
% pathUrm indica il path in cui e memorizzata la matrice urm di partenza
s=0.95;
passo=0.001;
soglia=0;

for i=1:size(cosRelation,1)
	cosRelation(i,i)=0; 
end;

%dimensione indica la dimensione della matrice di similarita
dimensione=(size(cosRelation,1)*size(cosRelation,2));

in=0;
while(s~=1&s<1)
s
in=in+1;
    %carico il file contente la matrice di similarita di ccui voglio
    %calcolare la soglia
    %path='d:\materiale tesi\distribuzioni coseno\';
    %load(strcat(path,'CosenoDistribuzioneUU0alpha1half.mat'));
    %cosRelation rappresenta la matrice di similarita user user di partenza
    cosRelation(find(cosRelation<s))=0;
    %zero indica il numero di elementi pari a zero della matrice
    zero=length(find(cosRelation(:)==0));
    if(zero~=dimensione)
        [app,c,d]=clusterDirReldaDR(cosRelation,'a',0);
        clus=zeros(max(app(:,1)),1);
        for i=1:size(app,1);
            clus(app(i,1))=app(i,2);
        end
        %uNoC indica il numero di utenti non clusterizzati per quella
        %soglia
        uNoC(in)=length(find(clus(:,1)==0))
        %cluster e  un verrore il cui indice indica il cluser e il cui
        %elemento indica il numero di utenti che appartengono a quel
        %cluster
        cluster=[];
        for i=1:max(clus)
            indici=find(clus==i);
            lunghezza=length(indici);
            cluster(i,1)=lunghezza;
        end
        indici=find(cluster==1);
        for i=1:size(indici,1)
            riga=find(clus==indici(i));
            clus(riga)=0;
        end
        cluster=[];
        for i=1:max(clus)
            indici=find(clus==i);
            lunghezza=length(indici);
            cluster(i,1)=lunghezza;
        end
        %umin indica il numero minimo di utenti che sono contenuti nei
        %cluster formati
        umin(in)=min(cluster)
        %umax indica il numero minimo di utenti che sono contenuti nei
        %cluster formati
        umax(in)=max(cluster)
        %numC indica il numero di cluster che si sono formati
        numC(in)=max(clus)
        soglia(in)=s;      

        if(numC>=cMin&numC<=cMax&uNoC>=noMin&uNoC<=noMax&umin>=uMin&umax<=uMax)
            s=1;
        else        
            s=s+passo;
        end
    end
    if(zero==dimensione)
       s=1.1;
       display('tutti ZERI');
    end
    
end

if(soglia==0)
    fprintf('nessuna soglia corrisponde ai paramentri\n');
else
    fprintf('hai rispettato tutti i parametri\n la soglia è: %d\n',soglia);
end
        

    
    





