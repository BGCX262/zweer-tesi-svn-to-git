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
%   METHODPARAMETERS.Folds (default 1)
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
    if(~isfield(MethodParameters, 'PercentageTest'))
        MethodParameters.PercentageTest = 0.01;
    end
    if(~isfield(MethodParameters, 'ProfileLength'))
        MethodParameters.ProfileLength = 0;
    end
    if(~isfield(MethodParameters, 'Folds'))
        MethodParameters.Folds = 1;
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
    
    
    [PositiveTestSet, NegativeTestSet] = extractTestSets(URM, MethodParameters.PercentageTest, -1, 0, MethodParameters.ProfileLength, -1, 1);
    
    [PositiveTests, NegativeTests, PositiveTestSet, NegativeTestSet, IndexesFoldsPos, IndexesFoldsNeg] = doMethod(MethodParameters.Folds, Algorithm, URM, PositiveTestSet, NegativeTestSet, ModelParameters, OnLineParameters);
    
    [Result.Recall, Result.IntervalBegin, Result.IntervalEnd] = computeConfidenceRecall(PositiveTests, 5, IndexesFoldsPos);
    
    rmpath(PathUtility);
end