function eta(i,cycleend,cputimestart,every)
%function eta(i,cycleend,start,every)
% segnala la durata (in termini di tempo cpu) del ciclo
% i = # iterazione del ciclo
% cycleend = totale iterazioni del ciclo
% start=cputime; prima del ciclo 
% every = ogni quanto stampare il messaggio ( es.: every=int32(cycleend/10000) ogni 10000 cicli stampa)

if(mod(i,every)==0)
    delta=cputime-cputimestart;
    
    perccompleted=i/cycleend;
    percremain=(1-perccompleted);
    eta=(percremain/perccompleted)*delta;
    
    strmes=strcat('time spent:',formattime(delta),' perc:',num2str(perccompleted*100,4), '% eta:',formattime(eta));
    sprintf('%s',strmes)
    
end
