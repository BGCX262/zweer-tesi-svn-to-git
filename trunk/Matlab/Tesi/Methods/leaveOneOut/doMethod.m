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
        return;
    end
    
    RefTime = tic;
    VectorTest(length(TestSet.i)).rating = -1;
    
    for test = 1:length(TestSet.i)
        user = TestSet.i(test);
        item = TestSet.j(test);
        ActiveUserVector = URM(user, :);
        ActiveUserVector(item) = 0;
        ViewedItems = find(ActiveUserVector);
        
        if(length(ViewedItems) < 2)
            VectorTest(test).item = item;
            VectorTest(test).user = user;
            VectorTest(test).pos = 1000;
            VectorTest(test).rating = -1;
        end
        
        OnLineParameters.userToTest = user;
        OnLineParameters.itemToTest = item;
        OnLineParameters.viewedItems = ViewedItems;
        
        RecList = R.onLineRecom(ActiveUserVector, OnLineParameters);
        RecList(ViewedItems) = -inf;
        
        [~, Col] = sort(-RecList);
        pos = find(Col == item);
        rating = RecList(item);
        
        VectorTest(test).item = item;
        VectorTest(test).user = user;
        VectorTest(test).pos = pos;
        VectorTest(test).rating = rating;
        
        if(mod(test, 100) == 0)
            displayRemainingTime(test, length(TestSet.i), RefTime);
        end
    end
end