function Result = initializeMethod(URM, URMProbe, Algorithm, MethodParameters, ModelParameters, OnLineParameters)
%INITIALIZEMETHOD initialize the given method, continuing its execution
%till the end, returning all the results.
%   INITIALIZEMETHOD(URM, URMPROBE, ALGORITHM...)
%   These parameters aren't optional: 
%   URM is the name of the user rating matrix.
%   URMPROBE is the name of the urm matrix used for the test.
%   ALGORITHM is the one used to compute the test.
%
%   (..., METHODPARAMETERS, MODELPARAMETERS, ONLINEPARAMETERS)
%   These parameters are optional. They specify the parameters used in a
%   particular moment of the test, the initialization, the creation of the
%   model and the computation of the rating. Each parameters must have a
%   Path attribute, set to the path of the test class.
%   METHODPARAMETERS.UnpopularThreshold (default 0) the threshold for the
%   unpopular results. It can be 0 (no unpopular), 0 < x < 1 for the
%   percentage or > 1 for the absolute value.
%   METHODPARAMETERS.PercentageTest (default 0.01)
%
%   The RESULT is a struct:
%   .RMSE
%   .Rank
    if(nargin < 6)
        help initializeMethod;
        return;
    end
    
    if(~isfield(MethodParameters, 'Path'))
        help initializeMethod;
        return;
    end
    if(~isfield(MethodParameters, 'ToBeConsideredThreshold'))
        MethodParameters.ToBeConsideredThreshold = 5;
    end
    if(~isfield(MethodParameters, 'UnpopularThreshold'))
        MethodParameters.UnpopularThreshold = 0;
    end
    if(~isfield(MethodParameters, 'PercentageTest'))
        MethodParameters.PercentageTest = 0.01;
    end
    
    if(~isfield(ModelParameters, 'Path'))
        help initializeMethod;
        return;
    end
    
    if(~isfield(OnLineParameters, 'Path'))
        help initializeMethod;
        return;
    end
    
    PathUtility = [MethodParameters.Path filesep 'Utility'];
    addpath(PathUtility);
    
    URMTrain = evalin('base', [URM ' - ' URMProbe]);
    
    if(MethodParameters.UnpopularThreshold < 1)
        ItemPivotPopular = findRatingPercentile(URMTrain, MethodParameters.UnpopularThreshold);
    elseif(MethodParameters.UnpopularThreshold > 0)
        ItemPivotPopular = MethodParameters.UnpopularThreshold;
    end
    
    [a, b] = find(URMProbe == MethodParameters.ToBeConsideredThreshold);
    TestSet = sparse(a, b, 1);
    if(MethodParameters.UnpopularThreshold > 0)
        TestSet(size(URMProbe, 1), size(URMProbe, 2)) = 0;
    end
    
    disp(['Size TestSet: ' num2str(nnz(TestSet))]);
    
    if(MethodParameters.UnpopularThreshold > 0)
        ItemsViews = zeros(1, size(URM, 2));
        
        for item = 1:size(URM, 2)
            ItemsViews(item) = sum(URMTrain(:, item), 1);
        end
        
        [PositiveTestSet, NegativeTestSet] = extractTestSets(TestSet, MethodParameters.PercentageTest, -1, -1, 0, ItemPivotPopular, 1, ItemsViews);
    else
        [PositiveTestSet, NegativeTestSet] = extractTestSets(TestSet, MethodParameters.PercentageTest);
    end
    
    [PositiveTests, NegativeTests] = doMethod(Algorithm, URM, URMTrain, PositiveTestSet, NegativeTestSet, ModelParameters, OnLineParameters);
    
    Result.RMSE = computeRMSE(PositiveTests, URM);
    Result.Rank = computeRank(PositiveTests);
    
    rmpath(PathUtility);
end