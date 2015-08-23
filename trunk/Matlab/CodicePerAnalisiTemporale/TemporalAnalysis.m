function [values]=TemporalAnalysis(urm,tsinit,tsend,begin,step,steprecall,soglia)
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
um=generateURMfromTimestampFull(urm,tsold-7,tsinit);
model1=createModel(um);
uu=generateURMfromTimestampFull(urm,tsold,tsinit);
matnovNA=[];
matnovA=[];
matnovNA(size(uu,1),size(uu,2))=0;
matnovA(size(uu,1),size(uu,2))=0;
for i=1:size(uu,1)
    prof=uu(i,:);
    rec=onLineRecom(prof,model1);
    rec(find(prof))=-inf;
    [m,n]=sort(-rec);
    matnovNA(i,n(1:10))=1; 
    matnovA(i,n(1:10))=1;
end
model1=[];
disp('Matrice iniziale novelty creata');
i=1;
tic();
while((t+steprecall<=tsend))
    ut1=generateURMfromTimestampFull(urm,t,tsinit);
    um1=generateURMfromTimestampFull(urm,t-7,tsinit);
    ut0=generateURMfromTimestampFull(urm,tsold,tsinit);
    um0=generateURMfromTimestampFull(urm,tsold-7,tsinit);
    uRecc=generateURMfromTimestampFull(urm,t+steprecall,t);
    mt1=createModel(ut1);
    mt0=createModel(ut0);
    udiff=ut1-ut0;
    voti=sum(udiff,2);
    pos=find(voti>0);
	h=1;
    for j=1:length(pos)
        if (length(find(ut0(pos(j),:)~=0)~=0))
        recold=onLineRecom(ut0(pos(j),:),mt0);
        recnew=onLineRecom(ut1(pos(j),:),mt1);
        recold(find(ut0(pos(j),:)))=-inf;
        recnew(find(ut1(pos(j),:)))=-inf;
        [a,b]=sort(-recold);
        [c,d]=sort(-recnew);
        [temp,matnovA]=Novelty(matnovA,b(1:10),pos(j));
        [temp,matnovNA]=Novelty(matnovNA,b(1:10),pos(j));
        diffNoAnti=compare_arrays(b(1:10),d(1:10));
        diffAnti=0;
        [lista_entranti,lista_uscenti,change]=check_inout(b(1:10),d(1:10));
            if (change~=0)
			
			 %mettere settaggi antireshuffling
            [listaAnti]=antiReshuffling(param);
            [e,f]=sort(-listaAnti);
            diffAnti=compare_arrays(b(1:10),f(1:10));
            [rA,tot]=getRecall(f(1:10),uRecc(pos(j),:));
            [novA,matnovA]=Novelty(matnovA,f(1:10),pos(j));
            end
        [rNA,tot]=getRecall(d(1:10),uRecc(pos(j),:)); 
        [novNA,matnovNA]=Novelty(matnovNA,d(1:10),pos(j));
        if (change==0)
            rA=rNA;
            novA=novNA;  
        end      
        totrate(h)=tot;
        rateokAnti(h)=rA;
        rateokNoAnti(h)=rNA;
        noveltyAnti(h)=novA;
        noveltyNoAnti(h)=novNA;
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
    values(i).novNoAnti=noveltyNoAnti;
    values(i).novAnti=noveltyAnti;
    tsold=t;
    t=t+step;
    i=i+1
end
end