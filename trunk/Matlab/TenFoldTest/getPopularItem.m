function [lista_pop]=getPopularItem(urm,soglia)

    if (soglia>1) 
        error('Soglia errata');
        return;
    end  
    urm=spones(urm);
    rate=sum(urm,1);
    total_vote=sum(rate,2);
    [i,j]=sort(-rate);
    i=abs(i);
    count=0;
    for k=1:length(rate)
        count=count+i(1,k);
        if (count>(total_vote*soglia))
            break;
    end
    for h=1:k
        lista_pop(h)=j(1,h);
    end
end