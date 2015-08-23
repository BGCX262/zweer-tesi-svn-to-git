function [lista_finale]=antiReshuffling (param)
% INPUT
% param.listavecchia = lista precedente completa 
% param.listanuova = lista attuale completa
% param.metrica = metrica utilizzata ('gapass','gapperc')
% param.soglia = soglia utilizzata
% param.confronto = 1 viene applicato il metodo2
%					2 non viene applicato il metodo2
% param.list_length = lunghezza della lista Top-N
% OUTPUT
% lista_finale = lista finale dopo l'applicazione del metodo di Antireshuffling
	

	if (lenght(param.listavecchia)~=length(param.listanuova))
	 disp('le liste hanno lunghezza differente');
	 exit();
	end
	
	if (param.metrica~='gapass')||(param.metrica~='gapperc')
	 disp('Metrica non riconosciuta');
	 exit();
	end
	
	if (~exist(param.soglia)
		if (param.metrica=='gapass')
			  param.soglia=0.2;
		end
		if (param.metrica=='gapperc')
			  param.soglia=0.9;
		end
	end
	
	if (param.metrica=='gapass')
		  param.confronto=1;
	end
	
	if (param.metrica=='gapperc')
		  param.confronto=0;
	end
	
	if (~exist(param.confronto))
	 disp('param.confronto non settato');
	 exit();	 
	end
	
	if (~exist(param.list_length))
	 disp('list_length settato in automatico a 10');
	 param.list_length=10;
	end
	
	listavecchia=param.listavecchia;
	listanuova=param.listanuova;
	metrica=param.metrica;
	soglia=param.soglia;
	confronto=param.confronto;	
	list_length=param.list_length;
	
    [i,j]=sort(-listavecchia);
    [h,k]=sort(-listanuova);
	% trovo i film entranti ed uscenti
    [lista_entranti,lista_uscenti,change]=check_inout(j(1:list_length),k(1:list_length));
	% se non ho cambiamenti tra le due liste ritorno altrimenti applico l'antireshuffling
    if (change==0)
    lista_finale=listanuova;
     else
	[lista_finale]=getFinalList(listavecchia,listanuova,lista_entranti,lista_uscenti,metrica,soglia,confronto);
    end
    lista_finale(find(profilo))=-inf;
end