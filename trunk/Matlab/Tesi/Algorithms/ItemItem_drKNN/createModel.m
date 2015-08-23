function Model = createModel(URM, Param)
%CREATEMODEL creates the model of the given user-ratings matrix using the
%ItemItem_drKNN Algorithm.
%   MODEL = CREATEMODEL(URM, PARAM)
%   has one optional parameter.
%   PARAM.drCos if set is the drCos used by the function.
%   PARAM.knn (default the number of URM's cols) is the number of K to
%   consider in dr matrix.
%   PARAM.Model if set is the model of the function
%
%   MODEL is a struct with:
%   MODEL.II (the model itself)
    
    if(nargin < 1)
        help createModel;
        return;
    end

    if(~exist('Param', 'var'))
        drCos = full(URM' * URM);
        knn = size(URM, 2);
    else
        if(isfield(Param, 'Model'))
            Model = Param.Model;
            return;
        end
        
        if(isfield(Param, 'drCos'))
            drCos = full(Param.drCos);
        else 
            drCos = full(URM' * URM);
        end
        
        if(isfield(Param, 'knn'))
            knn = Param.knn;
        else 
            knn = size(URM, 2);
        end
    end
    
    if(knn < size(drCos, 2))
        for i = 1:size(drCos,2)
            drCos(i, i) = 0;
        end
        
        II = sparse(size(drCos, 1), size(drCos, 2));
        
        for i = 1:size(II, 2)
           colItem = drCos(:, i);
           [~, c] = sort(colItem, 'descend');
           itemToKeep = c(1:knn);
           II(itemToKeep ,i) = drCos(itemToKeep, i);
        end
    else
        II = drCos;
    end
    
    Model.II = II; 
end