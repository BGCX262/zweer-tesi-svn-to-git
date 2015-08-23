function [recomList] = onLineRecom_pearsonIIkoren_unbiased (userProfile, model,param)
%userProfile = vector with ratings of a single user
%model = model created with createModel function 
%model  .II
%       .mu
%       .bi
%       [.bu] && [.userToTest]
%       [.lambdaU] -->  shrinking factor per media user b_{u}
%param.knn = [optional] k-nearest neighbors>
%param.postProcessingFunction = handle of post-processing function (e.g., business-rules)

    try
        II = model.dr;
        mu = model.mu;
        bi = model.bi;
        if (isfield(model,'bu') && isfield(param,'userToTest'))
            bu = model.bu;
            userToTest = param.userToTest;
        else
            lambdaU = model.lambdaU;
        end          
        if (isfield(model,'knn'))
            knnModel=model.knn;
        else
            knnModel=inf;
        end
    catch e
        error(' -- onLineRecom_pearsonIIkoren: missing fields in the model!');
    end
    
    ratedItems = find(userProfile);
    userProfileNormalized = full(userProfile);
    userProfileNormalized(ratedItems) = userProfileNormalized(ratedItems) -mu - bi(ratedItems);
    if (isfield(model,'bu') && isfield(param,'userToTest'))
        bu_currentUser = bu(userToTest);
    else
        bu_currentUser = sum(userProfileNormalized) / (lambdaU + length(ratedItems));
    end
    userProfileNormalized(ratedItems) = userProfileNormalized(ratedItems) - bu_currentUser;
    
    % filtering KNN!
    if (nargin>=3)
        if (isfield(param,'knn'))
            knn=param.knn;
            if (knn<size(II,2) && knn<knnModel)
                II = filterKnn(matrix,knn);
            end
        end
    end
    

    %normVector = sum(II(ratedItems,:),1);
    %normVector(isnan(normVector)) = 1;
    %recomList = ((mu + bu_currentUser) + bi) + ((userProfileNormalized*II) ./ normVector);
    recomList = ((mu + bu_currentUser) + bi) + ((userProfileNormalized*II));
    
    if (nargin>=3)
        if(strcmp(class(param.postProcessingFunction),'function_handle'))
            recomList=feval(param.postProcessingFunction,recomList,param);
        end
    end
    
end