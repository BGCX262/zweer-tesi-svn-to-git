function [values]=FixedModel(urm,tsinit,tsend,begin,step,steprecall,soglia)
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
model=createModel(u);
i=1;
tic();
while((t+steprecall<=tsend))
    u2=generateURMfromTimestampFull(urm,t,tsinit);
    u3=generateURMfromTimestampFull(urm,tsold,tsinit);
    uRecc=generateURMfromTimestampFull(urm,t+steprecall,t);
    udiff=u2-u3;
    voti=sum(udiff,2);
    pos=find(voti>0);
	h=1;
    for j=1:length(pos)
        if (length(find(u3(pos(j),:)~=0)~=0))
        recold=onLineRecom(u3(pos(j),:),model);
        recnew=onLineRecom(u2(pos(j),:),model);
        recold(find(u3(pos(j),:)))=-inf;
        recnew(find(u2(pos(j),:)))=-inf;
        [a,b]=sort(-recold);
        [c,d]=sort(-recnew);
        diffNoAnti=compare_arrays(b(1:10),d(1:10));
        diffAnti=0;
        rA=NaN;
        [lista_entranti,lista_uscenti,change]=check_inout(b(1:10),d(1:10));
            if (change~=0)
            %mettere settaggi antireshuffling
            [listaAnti]=antiReshuffling(param);
            listaAnti(find(u2(pos(j),:)))=-inf;
            [e,f]=sort(-listaAnti);
            diffAnti=compare_arrays(b(1:10),f(1:10));
            [rA,tot]=getRecall(f(1:10),uRecc(pos(j),:));
            end
        [rNA,tot]=getRecall(d(1:10),uRecc(pos(j),:));  
        totrate(h)=tot;
        rateokAnti(h)=rA;
        rateokNoAnti(h)=rNA;
        vectNoAnti(h)=diffNoAnti;
        vectAnti(h)=diffAnti;
		h=h+1;
        end
    end
    values(i).totRate=totrate;
    values(i).rateokNoAnti=rateokNoAnti;
    values(i).rateokAnti=rateokAnti;
    values(i).vetNoAnti=vectNoAnti;
    values(i).vetAnti=vectAnti;
    tsold=t;
    t=t+step;
    i=i+1
	toc();
end
end