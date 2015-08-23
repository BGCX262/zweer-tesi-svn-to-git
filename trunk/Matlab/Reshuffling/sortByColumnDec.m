function [matrix]=sortByColumnDec(m,col)
%Funzione che ordina una determinata matrice in ordine decrescente secondo il valore di una determinata colonna
    matrix=m;
    for i=1:size(m,1)
        a=max(m(:,col));
        for j=1:size(m,1)
            if(m(j,2)==a)
                matrix(i,1)=m(j,1);
                matrix(i,2)=m(j,2);
                m(j,2)=-inf;
                break;
            end
        end
    end     

end