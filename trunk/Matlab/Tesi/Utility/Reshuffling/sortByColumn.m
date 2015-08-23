function Sorted = sortByColumn(Matrix, Col, Asc)
%SORTBYCOLUMNASC(MATRIX, COL, ASC) sorts Matrix in ascending order, according to
%the values of Col column.
%   One optional parameter.
%   If ASC is set and equal to 'desc' the sorting is done in descending
%   order. Otherwise in ascending order.
    if(nargin < 2)
        help sortByColumn
        return;
    end
    
    if(exist('Asc', 'var') == 0)
        Asc = 'asc';
    end
    
    Sorted = Matrix;
    
    if(strcmp(Asc, 'desc') == 1)
        Signum = -1;
    else
        Signum = +1;
    end
    
    for i = 1:size(Matrix, 1)
        if(strcmp(Asc, 'desc') == 1)
            a = max(Matrix(:, Col));
        else
            a = min(Matrix(:, Col));
        end
        
        for j = 1:size(Matrix, 1)
            if(Matrix(j, 2) == a)
                Sorted(i, 1) = Matrix(j, 1);
                Sorted(i, 2) = Matrix(j, 2);
                Matrix(j, 2) = Signum * +inf;
                break;
            end
        end
    end
end