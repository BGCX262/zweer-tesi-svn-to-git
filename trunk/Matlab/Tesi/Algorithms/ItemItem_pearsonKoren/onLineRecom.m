function RecomList = onLineRecom(UserProfile, Model, Param)
%ONLINERECOM generates the vector with ratings of a single user with the
%ItemItem_PearsonKoren Algorithm.
%   ONLINERECOM(USERPROFILE, MODEL, PARAM)
%   has no optional parameter.
%   USERPROFILE is the profile of our user. It can be also a row of the urm
%   matrix.
%   MODEL is the one created with createModel function.
%   PARAM.Path must be set to include the utility directory.
%   PARAM.postProcessingFunction handles the post-processing function
%   PARAM.knn is the k-nearest neighbors
    
    if(nargin < 3)
        help onLineRecom;
        return;
    end
    
    if(~isfield(Param, 'Path'))
        help onLineRecom;
        return;
    end
    
    Path = [Param.Path filesep 'Utility'];
    addPath(Path);
    
    try
        dr = Model.dr;
        mu = Model.mu;
        bi = Model.bi;
        lambdaU = Model.lambdaU;            
        if(isfield(Model, 'knn'))
            knnModel = Model.knn;
        else
            knnModel = inf;
        end
    catch e
        error(' -- onLineRecom_pearsonIIkoren: missing fields in the model!');
    end
    
    ratedItems = find(UserProfile);
    UserProfileNormalized = full(UserProfile);
    UserProfileNormalized(ratedItems) = UserProfileNormalized(ratedItems) - mu - bi(ratedItems);
    bu_currentUser = sum(UserProfileNormalized) / (lambdaU + length(ratedItems));
    UserProfileNormalized(ratedItems) = UserProfileNormalized(ratedItems) - bu_currentUser;
    
    if(isfield(Param, 'knn'))
        knn = Param.knn;
        if(knn < size(dr, 2) && knn < knnModel)
            dr = filterKnn(matrix, knn);
        end
    end
    
    normVector = sum(dr(ratedItems, :), 1);
    normVector(isnan(normVector)) = 1;
    RecomList = ((mu + bu_currentUser) + bi) + ((UserProfileNormalized * dr) ./ normVector);
    
    if(strcmp(class(Param.postProcessingFunction), 'function_handle'))
        RecomList = feval(Param.postProcessingFunction, RecomList, Param);
    end
    
    rmpath(Path);
end