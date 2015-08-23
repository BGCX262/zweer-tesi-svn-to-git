function [values]=FixedProfile(urm,tsinit,tsend,begin,step,steprecall,soglia)
%   INPUT
%	urm = urm con timestamp	
%	tsinit = timestamp iniziale
%	tsend = timestamp finale
%	begin = valore di tempo dopo il quale iniziare le misurazioni
%	step = intervallo per le misurazioni
%	steprecall = intervallo per la valutazione della recall
%	soglia = soglia per l'antireshuffling

% 	OUTPUT
%	valori di resh senza e con antireshuffling, valori di novelty per tutti gli istanti temporali


	tsold=tsinit+begin;
	t=tsold+step;
	u=generateURMfromTimestampFull(urm,tsold,tsinit);
	voti=sum(u,2);
	pos=find((voti>0)&(voti<11));
	numTest=0.1*size(u,1);
	posTest=[];
		for m=1:numTest
			lung=length(pos);
			index=round((rand*(lung-1)) +1);
			posTest=cat(1,posTest,pos(index));
		end
	utentiTest=(u(posTest,:));
	i=1;
		while((t+steprecall<=tsend))
			uold=generateURMfromTimestampFull(urm,tsold,tsinit);
			unew=generateURMfromTimestampFull(urm,t,tsold);
			uRecc=generateURMfromTimestampFull(urm,t+steprecall,t);
			uold(posTest,:)=[];
			unew(posTest,:)=[];
			totrate=0;
			rateokNoAnti=0;
			rateokAnti=0;
			modelold=createModel(uold);
			modelnew=createModel(unew);
			for j=1:length(posTest)
				prof=utentiTest(j,:);
				recold=onLineRecom(prof,modelold);
				recnew=onLineRecom(prof,modelnew);
				recold(find(prof))=-inf;
				recnew(find(prof))=-inf;
				[a,b]=sort(-recold);
				[c,d]=sort(-recnew);
				diffNoAnti=compare_arrays(b(1:10),d(1:10));
				diffAnti=0;
				rA=NaN;
				[lista_entranti,lista_uscenti,change]=check_inout(b(1:10),d(1:10));
					if (change~=0)
					%mettere settaggi antireshuffling
					[listaAnti]=antiReshuffling(param);
					[e,f]=sort(-listaAnti);
					diffAnti=compare_arrays(b(1:10),f(1:10));
					[rA,tot]=getRecall(f(1:10),uRecc(posTest(j),:));
					end
				[rNA,tot]=getRecall(d(1:10),uRecc(posTest(j),:));  
				totrate(j)=tot;
				rateokAnti(j)=rA;
				rateokNoAnti(j)=rNA;
				vectNoAnti(j)=diffNoAnti;
				vectAnti(j)=diffAnti;
			end
			values(i).totRate=totrate;
			values(i).rateokNoAnti=rateokNoAnti;
			values(i).rateokAnti=rateokAnti;
			values(i).vetNoAnti=vectNoAnti;
			values(i).vetAnti=vectAnti;
			tsold=t;
			t=t+step;
			i=i+1
		
		end
end