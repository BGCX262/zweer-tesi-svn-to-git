function [lista_finale]=checkList(listavecchia,listanuova,lista_entranti,lista_uscenti,lista_ent_gap,lista_usc_gap,soglia,confronto)
% Questa funzione valuta i film entranti ed uscenti in base a metrica utilizzata e soglia restituendo la lista finale completa
% Se confronto = 1 viene applicato anche il metodo2 (da utilizzare con Gap Posizione Percentuale)
% Se confronto = 0 non viene applicato il metodo2 (da utilizzare con Gap Posizione Assoluta)


%costruisco le 2 matrici con film e relativo gap percentuale
matrice_ent=cat(2,lista_entranti,lista_ent_gap);
matrice_usc=cat(2,lista_uscenti,lista_usc_gap);
%ordino le due matrici, quella degli entranti in ordine decrescente secondo
%l'incremento del gap,mentre quella degli uscenti in ordine crescente in
%modo che nelle prime posizioni abbia gli elementi che hanno avuto
%incremento del gap minore o un decremento
matrice_ent=sortByColumnDec(matrice_ent,2);
matrice_usc=sortByColumnAsc(matrice_usc,2);
%controllo gli elementi della lista entranti che superano la soglia e li
%metto nella lista dei candidati entranti

%METODO 1 parte 1
    matrice_ent(find(matrice_ent(:,2)>=soglia),1:2)=-Inf;
    k=length(find(matrice_ent(:,1)==-Inf));
	
%controllo se ho elementi nella lista dei candidati entranti, se si prendo
%gli elementi della lista uscenti con gap minore e  li metto nella lista
%candidati uscenti, dopodichè controllo quali
%elementi della lista uscenti sono inferiori alla meno soglia e li metto nella lista
%candidati uscenti

%METODO 1 parte 2
    if (k>0)
        for n=1:k
            matrice_usc(n,:)=-Inf;
        end
   
        h=0;
        
        for n=1:size(matrice_usc,1)
            if(matrice_usc(n,2)<-soglia)
                h=h+1;
                matrice_usc(n,:)=-Inf;
            end
        end
        if (h>0)
            l=size(matrice_ent,1);
            for n=1:h
                matrice_ent(n,:)=-Inf;
            end
        end
% elimino dalle liste entranti ed uscenti i film inseriti nelle liste candidate 

ko=find(matrice_ent(:,2)==-Inf);
matrice_ent(ko,:)=[];

ko=find(matrice_usc(:,2)==-Inf);
matrice_usc(ko,:)=[];

%applichiamo il confronto

%METODO 2
if (confronto==1)
	{
		h=1;
		for n=1:size(matrice_ent,1)
			if ((matrice_ent(n,2)-matrice_usc(n,2))>=((soglia)/2))
				h=h+1;
				matrice_ent(n,:)=-Inf;
				matrice_usc(n,:)=-Inf;
			end
		end
	 % elimino dalle liste entranti ed uscenti i film inseriti nelle liste
	 % candidate 
	ko=find(matrice_ent(:,2)==-Inf);
	matrice_ent(ko,:)=[];

	ko=find(matrice_usc(:,2)==-Inf);
	matrice_usc(ko,:)=[];
	}

%effettuo lo scambio dei punteggi e restituisco la lista finale
   for n=1:l

       matrice_ent(n,2)=listanuova(1,matrice_ent(n,1));
       matrice_usc(n,2)=listanuova(1,matrice_usc(n,1));
   end
   matrice_ent=sortByColumnDec(matrice_ent,2);
   matrice_usc=sortByColumnDec(matrice_usc,2);
   for n=1:l
       temp=listanuova(1,matrice_ent(n,1));
       listanuova(1,matrice_ent(n,1))=listanuova(1,matrice_usc(n,1));
       listanuova(1,matrice_usc(n,1))=temp;     
   end  
  
  lista_finale=listanuova;
 
end
