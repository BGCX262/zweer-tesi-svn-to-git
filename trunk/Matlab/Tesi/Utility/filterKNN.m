function Matrix = filterKNN(Matrix, Knn, Diagonal)
%FILTERKNN applies a knn filter to the matrix passed, i.e., keeps the
%largest 'knn' values for each column. The output is a sparse matrix.
%   FILTERKNN(MATRIX, KNN, DIAGONAL)
%   has one optional parameter.
%   DIAGONAL (default true) whether to set to zero all elements in the main
%   diagonal.
% 

    if(~exist('Diagonal', 'var'))
        Diagonal = true;
    end

    if(Diagonal)
        for i = 1:size(Matrix, 2)
            Matrix(i, i) = 0;  
        end  
    end
    
    II = sparse(size(Matrix, 1), size(Matrix, 2));
    
    for i = 1:size(II, 2)
       colItem = Matrix(:, i);
       try
            [~, c] = sort(colItem, 1, 'descend');
       catch e
            display(['warning in filterKNN, column ' num2str(i)]);
            [~, c] = sort(full(colItem), 1, 'descend');
       end
        
       itemToKeep = c(1:Knn);
       II(itemToKeep, i) = Matrix(itemToKeep,i);
    end
    
    Matrix = II;
end