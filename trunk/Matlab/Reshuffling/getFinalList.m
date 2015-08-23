function [lista_finale]=getFinalList (listavecchia,listanuova,lista_entranti,lista_uscenti,metrica,soglia,confronto)
% Funzione che richiama le funzioni per il calcolo dei gap e la gestione degli scambi, restituisce la lista finale di raccomandazione
	if (metrica=='gapass')
	soglia=soglia* length(listavecchia);
	lista_ent_gap=calculate_position_gap_ass(lista_entranti,listavecchia,listanuova);
	lista_usc_gap=calculate_position_gap_ass(lista_uscenti,listavecchia,listanuova);
	end
	if (metrica=='gapperc')	
	lista_ent_gap=calculate_position_gap_perc(lista_entranti,listavecchia,listanuova);
	lista_usc_gap=calculate_position_gap_perc(lista_uscenti,listavecchia,listanuova);
	end
[lista_finale]=checkList(listavecchia,listanuova,lista_entranti,lista_uscenti,lista_ent_gap,lista_usc_gap,soglia,confronto);
end