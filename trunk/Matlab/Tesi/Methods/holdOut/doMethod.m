function [PositiveTests, NegativeTests] = doMethod(Algorithm, URM, URMTrain, PositiveTestSet, NegativeTestSet, ModelParameters, OnLineParameters)
%DOMETHOD is the core script of the method. It only takes care of the
%evaluation, leaving the preparation of the datas and the computation of
%the results to the initialize function.
%   [POSITIVETESTS, NEGATIVETESTS] = DOMETHOD(ALGORITHM, URM, URMTRAIN...)
%   It returns the positive and negative tests.
%   ALGORITHM is the algorithm to be used in the model computation and in
%   the creation of the recommendation.
%   URM is the user-item matrix.
%   URMTRAIN is the user-item matrix to be used for the training. It is
%   part of the URM.
%   DOMETHOD(..., POSITIVETESTSET, NEGATIVETESTSET...)
%   POSITIVETESTSET and NEGATIVETESTSET are the testsets to be used in the
%   evaluation of the test.
%   DOMETHOD(..., MODELPARAMETERS, ONLINEPARAMETERS)
%   MODELPARAMETERS is a struct with all the parameters to be passed to the
%   createModel function. It must contain a Path parameter with the path of
%   the Test object.
%   ONLINEPARAMETERS is a struct with all the parameters to be passed to
%   the onLine function. It must contain a Path parameter with the path of
%   the Test object.
    
    if(nargin < 7)
        help doMethod;
        return;
    end
    
    if(~isfield(ModelParameters, 'Path'))
        help doMethod;
        return;
    end
    
    if(~isfield(OnLineParameters, 'Path'))
        help doMethod;
        return;
    end
    
    PathUtility = [MethodParameters.Path filesep 'Utility'];
    addpath(PathUtility);
    
    R = Recommendation(URMTrain, Algorithm);
    R.createModel(ModelParameters);
    
    PositiveTests = buildVectorTest(PositiveTestSet, URM, R, OnLineParameters);
    NegativeTests = buildVectorTest(NegativeTestSet, URM, R, OnLineParameters);
    
    rmpath(PathUtility);
end

function VectorTest = buildVectorTest(TestSet, URM, R, OnLineParameters)
    if(isempty(TestSet.i))
        VectorTest = [];
    end
    
    count = 0;
    
    for user = 1:size(URM, 1)
        itemsToTest = TestSet.j(find(TestSet.i == user));
        VectorActiveUser = URM(user, :);
        VectorActiveUser(itemsToTest) = 0;
        ViewedItems = find(VectorActiveUser);
        
        if(length(ViewedItems) < 2 || length(itemsToTest) < 1)
            continue;
        end
        
        R.Model.userID = user;
        OnLineParameters.testedItems = itemsToTest;
        RecList = R.onLineRecom(VectorActiveUser, OnLineParameters);
        RecList(ViewedItems) = -Inf;
        
        [Rows, Cols] = sort(-RecList);
        
        for index = 1:length(itemsToTest)
            count = count + 1;
            item = itemsToTest(index);
            pos = find(Cols == item);
            rating = RecList(item);
            VectorTest(count).item = item;
            VectorTest(count).user = user;
            VectorTest(count).pos = pos;
            VectorTest(count).rating = rating;
            
            if(mod(count, 500) == 0)
                %disp(count);
            end
        end
    end
end