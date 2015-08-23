function [app,c,d] =clusterDirReldaDR(A,norm,param)


%salvo la diagonale
%d=diag(dr);
d=diag(A);

if (strcmp(norm,'snorm'))
	fprintf('effettuo normalizzazione snorm\n');
    A=Snorm(A,param);
elseif (strcmp(norm,'cad'))
	fprintf('effettuo normalizzazione cad\n');
    A=Cad(A,param);
elseif (strcmp(norm,'cadsnorm'))
	fprintf('effettuo normalizzazione cad+snorm\n');
    A=CadSnorm(A,param);
end

%pongo la diagonale della matrice a zero
for i=1:length(A)
    A(i,i)=0;
end

%fprintf('normalizzazione effettuata, calcolo i cluster\n');

[pi po]=find(A==max(max(A)));

%k=pi(1,1);
k=1;
p=[]; 
%c è la matrice di output ix2 (dove i sono tutti gli indici significativi della matrice A), dove ogni riga corrisponde ad una coppia di nodi unita da un arco orientato dal nodo c(i,1) al nodo c(i,2).
c=[];
%cc tiene conto ad ogni iterazione degli indici i visitati e viene usato per aggiornare c
cc=[];

%p è quindi un vettore che stabilisco in base alla lunghezza di A
p=1:1:length(A);



maxClus=1;
app=[];

while(k<=length(A) )
    %se la riga della matrice A non contiene tutti zeri, quindi se è una riga significativa
    if(length(find(A(k,:))~=0))
       %prendo l'indice del massimo di tale riga
       [s i] = max(A(k,:));
       %aggiorno il vettore di output
       app=[app; k maxClus s];
       %lo salvo in c assieme al valore del massimo della i-esima riga 
       % quindi aggiorno c con k(nodo di partenza), i(nodo di arrivo), s(massimo di tale riga)
       c=[c;k i s];
       j=0;
       cc=[cc;k];
       %pongo a zero l'elemento k-esimo del vettore p(quindi non visiterò più la k-esima riga) 
       p(k)=0;
         
       %finchè cc non ha uno zero(che segna la fine di un cluster e l'inizio di un altro) e finchè il     
       %vettore p ha l'indice i diverso da zero entro nel ciclo
       while(length(find(cc==i))==0 & find(p==i))
          %assegno l'ultimo nodo visitato a j (che ora diviene il nodo di partenza)
          j=i;
          %ottengo l'indice corrispondente al nuovo massimo della riga i (cioè j) che sto visitando della 		  
          %matrice A, quindi dopo questa istruzione i cambia 
          [s i]=max(A(i,:));
          %aggiorno il vettore di output
          app=[app; j maxClus s];
          %aggiorno c con j(ultimo nodo visitato - nodo di partenza), i(nodo di arrivo), s(massimo
          %corrisondente alla riga j)
          c=[c;j i s];
          %aggiorno cc
          cc=[cc;j];
          %pongo a zero il j-esimo elemento di p, così non visiterò più tale riga di A
          p(j)=0;     
       end

       %se p non contiene tutti zeri
       if(length(find(p))~=0)
           %trova gli elementi di p diversi da zero e assegnali ad un nuovo vettore a
           a=find(p);
           %aggiorna l'indice k con il primo elemento di tale vettore, che è di sicuro un riga della 
           %matrice A che non ho ancora controllato
           k=a(1);
        else 
           %se cosi non è, esci  
           break;
       end
        
       %lavoro su app per trovare le relazioni dirette e transitive
       %salvo in temp le tuple di app che contengono il valore i, valore
       %appena visitato che era gi� stato visitato in precendenza
        temp=app(find(app(:,1)==i),:);
        %cerco il cluste di appartenenza minore
        valMinGlobale=min(temp(:,2));
        %torno in dietro in c fino al primo 0
        v=size(c,1);
        while v>0 && (c(v,1)>0) 
           v=v-1;
        end
        v=v+1;
        %tutti le tuple di app dall'ultimo 0 fino alla fine avranno come
        %cluster di appartenenza il cluster minimo calcolato grazie alla
        %relazione transitiva con il cluster appena visitato
        app(v:size(app,1),2)=valMinGlobale;
        maxClus=max(app(:,2))+1;
        app=[app; 0 0 0];
            
       
        %a questo punto si è di sicuro alla fine di un cluster, perciò si pone una riga di zeri nella
        %matrice c
        c=[c;0 0 0];
    %se la riga A contiene tutti zeri
    else
        %pongo a zero comunque in p il k-esimo indice, in modo tale che non lo controllerò più
        p(k)=0;
        %se ci sono ancora righe da visitare in A, quindi p non ha tutti zeri
        if(length(find(p))~=0)
           %trovo tali elementi diversi da zero in p e li assegno ad a
           a=find(p);
           %aggiorno k con il primo elemento di a, che è di sicuro una riga di A che non ho ancora
           %guardato
           k=a(1);
        else
            %altrimenti esco
            break;
        end
        %fine di questo if
    end
    %fine dell'if che si riferisce alle righe significative di A
end
%fine del while che stabilisce se k è <= della lunghezza di A
%pulisco app dagli 0

    app(find(app(:,1)==0),:)=[];
    %display(strcat('cluster creati: ',int2str(max(full(app(:,2))))));

end
%fine della funzione cluster
