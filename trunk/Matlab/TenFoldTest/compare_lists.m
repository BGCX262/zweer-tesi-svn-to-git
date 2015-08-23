function [values]=compare_lists(lists,listapop,resh,list_length)
% INPUT 

% OUTPUT


        pp=1;
        pnp=1;
        npnp=1;
        npp=1;
        vectpnp=[];
        vectnpnp=[];
        vectpp=[];
        vectnpp=[];
       for i=1:length(lists)
              [m,n]=sort(-lists(i).listabase);
              orig=n(1:list_length);
              pop=lists(i).popolare;
                  if (resh==0)
                    lista=lists(i).nuovalista;
                  else
                    lista=lists(i).listaAnti;
                  end
              [m,n]=sort(-lista);
              lista=n(1:list_length);
              vototolto=lists(i).itemtolto;
              diff=compare_arrays(orig,lista);
              bool=find(listapop==vototolto);
                  if (pop==1)
                     if (length(bool)==0)
                      vectpnp(pnp)=diff;
                      pnp=pnp+1; 
                     else
                      vectpp(pp)=diff;
                      pp=pp+1; 
                     end
                  else 
                     if (length(bool)==0)
                      vectnpnp(npnp)=diff;
                      npnp=npnp+1;  
                     else
                      vectnpp(npp)=diff;
                      npp=npp+1;       
                     end     
                  end
       end %finefor
     values.vectpp=vectpp;
     values.vectpnp=vectpnp;
     values.vectnpp=vectnpp;
     values.vectnpnp=vectnpnp;
     
end