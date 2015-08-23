function IIAdjCos=AdjustedCosine(urm,soglia)
%function IIAdjCos=AdjustedCosine(urm,soglia)
[user,movie]=size(urm);
IIAdjCos=zeros(movie,movie);
start=cputime;
every=2;

for i=1:movie
    X=urm(:,i);
    for j=i:movie    
        Y=urm(:,j);
        inters=X & Y;
        if (isempty(inters)==0)
            ind=find(inters);
            Xa=X(ind);            
            Ya=Y(ind);
            %ris=sum(Xa.*Ya)/sqrt(sum(Xa.^2)*sum(Ya.^2));
            ris=Xa'*Ya/sqrt(Xa'*Xa*Ya'*Ya);
            if(ris>=soglia)
                IIAdjCos(i,j)=ris;
                IIAdjCos(j,i)=ris;
            end
        end
    end
    eta(i,movie,start,every);
end