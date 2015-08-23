function [model] = createModel (URM,param)
% URM = matrix with user-ratings

    if (exist('param')==0)
        %URM=normalizeWordsMatrix(URM,2);
        URM=normalizeColsMatrix(URM);
        drCos=URM'*URM;
    else
        drCos = param.drCos;
    end
    
    model.drCos = drCos; 
end