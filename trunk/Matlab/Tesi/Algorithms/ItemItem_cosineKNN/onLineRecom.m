function RecomList = onLineRecom(UserProfile, Model, Param)
%ONLINERECOM generates the vector with ratings of a single user with the
%ItemItem_CosineKNN Algorithm.
%   ONLINERECOM(USERPROFILE, MODEL, PARAM)
%   has one optional parameter.
%   USERPROFILE is the profile of our user. It can be also a row of the urm
%   matrix.
%   MODEL is the one created with createModel function.
%   PARAM is optional.
%   PARAM.knn is the number of the k-nearest neightbors
%   PARAM.postProcessingFunction handles the post-processing function
    
    if(nargin < 2)
        help onLineRecom;
        return;
    end

    dr = Model.II;
    
    if(nargin >= 3)
        if(isfield(Param, 'knn'))
            knn = Param.knn;
            if(knn < size(dr,2))
                for i = 1:size(dr,2)
                    dr(i, i) = 0;
                end
                
                II = sparse(size(dr, 1), size(dr, 2));
                
                for i = 1:size(II, 2)
                   colItem = dr(:, i);
                   [~, c] = sort(colItem, 1, 'descend');
                   itemToKeep = c(1:knn);
                   II(itemToKeep, i) = dr(itemToKeep, i);
                end
                dr = II;
            end
        end
    end
    
    RecomList = UserProfile * dr;
    
    if(nargin >= 3)
        if(isfield(Param, 'postProcessingFunction'))
            RecomList = feval(Param.postProcessingFunction, RecomList, Param);
        end
    end
    
end