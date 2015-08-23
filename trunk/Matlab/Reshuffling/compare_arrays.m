function [diff]=compare_arrays(array1,array2)
% INPUT 
% array1 = primo array per il confronto
% array2 = secondo arraty per il confronto
% OUTPUT
% diff   = numero di elementi per cui il secondo array differisce dal  primo
        %se gli array non hanno ugual dimensioni non sono confrontabili
        if ((length(array1)) ~= (length(array2)))
            error('Gli array hanno dimensioni differenti');
        end
        diff=0;
        % per ogni elemento che di differenza incremento il contatore
        % restituito dalla funzione
        for i=1:length(array1)
            elem=array1(i);
            found=0;
            for k=1:length(array2)
                if (elem==array2(k))
                    found=1;
                end
            end
            if (found==0)
                diff=diff+1;
            end
        end
end