function [tab,values] = TenFoldTestCompleteEvaluationImplicit(param)
%   INPUT
%	param.URM = Matrice URM con le righe mischiate e nell'ultima colonna il numero del profilo utente
%   param.lb = soglia inferiore lunghezza profili da utilizzare
%   param.ub = soglia superiore lunghezza profili da utilizzare
%	param.metrica = metrica per l'algoritmo antiReshuffling ('gapass','gapperc');
%   param.sogliaresh = soglia per l'algoritmo di Reshuffling
%   param.sogliaitem = percentuale di rating da considerare
%   param.list_length = lunghezza lista di raccomandazione
%   OUTPUT
%   tab = per la valutazione della qualità
%   values = per la valutazione del reshuffling
	urm=param.urm;
	list_length=param.list_length;
	m=max(urm);
	m=max(m);
	if (m>1)
		espl=1;
		else
		espl=0;
	end
    tic();
    %settaggio iniziale
    rand('twister',1);
    listapop=getPopularItem(urm,0.5);
    list=[];
    listIndex=1;
    %calcolo lunghezza fold
    dimFold=round(length(urm)/10);
      for i=1 : 10
        tabtest=[];
        tabmodel=[];
        lowerBound= ((i-1)*dimFold)+1;
        higherBound=dimFold*i;
        if(i==10)
            higherBound=length(urm);
        end
        %CALCOLO IL MODELLO
	    dimensione=size(urm);
        tabmodel=urm(:,1:dimensione(2)-1);       
        tabmodel(lowerBound:higherBound,:)=[];
		
		% cambiare codice se si utilizza LSACOSINE
        model=createModel(tabmodel);
        %CALCOLO LA TABELLA DI TEST E RICAVO I PROFILI DA TESTARE
        tabtest=urm(lowerBound:higherBound,:);
        profiliTest=getUtentiTest(tabtest,param.lb+2,param.ub+2);
        dimensioneprofili=size(profiliTest);
        dimensioneprofili=dimensioneprofili(1)
                for j=1 : dimensioneprofili                  
                profilo=profiliTest(j,:);
				if (espl)
					items=find(profilo==5);
					else
					items=find(profilo~=0);
				end
                codUtente=profilo(1,length(profilo));
                profilo=profilo(1,1:(length(profilo)-1));
                pos=find(profilo~=0); 
                        for k=1 : (length(items)-1)
                            temp=rand;
                            if (temp<=param.sogliaitem)
                                item=items(1,k);
                                profilo(1,item)=0;
								if (espl)
									temp2=find((profilo==4)|(profilo==5));
									else
									temp2=find(profilo~=0);
								end
                                lung=length(temp2);
                                index=round((rand*(lung-1)) +1); %funzione che genera un numero casuale da 1 alla lunghezza del profilo
                                                                 %per decidere quale item togliere dal profilo
                                ultimoitem=temp2(index);
								vototolto=profilo(1,ultimoitem);
                                profilo(1,ultimoitem)=0;
                                listabase=onLineRecom(profilo,model);
                                list(listIndex).codUtente=codUtente;
                                pop=isPopular(profilo,listapop);
                                list(listIndex).popolare=pop;
                                list(listIndex).itemEvaluation=item;
                                list(listIndex).itemtolto=ultimoitem;
                                listabase(find(profilo))=-inf;
                                list(listIndex).listabase=listabase;
                                bool=find(listapop==ultimoitem);
                                %calcolo della nuova lista senza reshuffling
                                profilo(1,ultimoitem)=votolto;
                                listaNoAnti=onLineRecom(profilo,model);
                                listaNoAnti(find(profilo))=-inf;
                                list(listIndex).nuovalista=listaNoAnti;
                                        if (sogliaresh~=-inf)
                                        % con una soglia diversa da meno infinito viene
                                        % applicato l'antireshuffling per il calcolo delle
                                        % liste di raccomandazione
										param2.listavecchia=listabase;
										param2.listanuova=listaNoAnti;
										param2.metrica=param.metrica;
										param2.soglia=param.sogliaresh;
                                        [listaAnti]=antiReshuffling(param2);
                                        list(listIndex).listaAnti=listaAnti;
                                        end
                                listIndex=listIndex+1;
								if (espl)
									profilo(1,item)=5;
									else
									profilo(1,item)=1;   
								end								
                             end %for if
                           end %for dei  items
                 end %for dei profili
      disp(i);
    end %for dei fold
        values.valuesNoAnti=compare_lists(list,listapop,0,list_length);
        if (param.sogliaresh~=-inf)
            values.valuesAnti=compare_lists(list,listapop,1,list_length);
        end
         tab.tabNoAnti=createTableEvaluation(list,0,listapop);
        if (param.sogliaresh~=-inf)
            tab.tabAnti=createTableEvaluation(list,1,listapop);
        end 
    
  end