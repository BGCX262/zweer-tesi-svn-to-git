function [PositiveTests, NegativeTests, PositiveTestSet, NegativeTestSet, IndexesFoldsPos, IndexesFoldsNeg] = doMethod(Folds, Algorithm, URM, PositiveTestSet, NegativeTestSet, ModelParameters, OnLineParameters)
%DOMETHOD is the core script of the method. It only takes care of the
%evaluation, leaving the preparation of the datas and the computation of
%the results to the initialize function.
%   [POSITIVETESTS, NEGATIVETESTS, POSITIVETESTSET, NEGATIVETESTSET, 
%   INDEXESFOLDSPOS, INDEXESFOLDSNEG] = DOMETHOD(FOLDS, ALGORITHM, URM, ..)
%   It returns the positive and negative tests.
%   FOLDS is the number of folds.
%   ALGORITHM is the algorithm to be used in the model computation and in
%   the creation of the recommendation.
%   URM is the user-item matrix.
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
    
    numUser = size(URM, 1);
    numRowsToTest = floor(numUser / Folds);
    
    PositiveTests = [];
    NegativeTests = [];
    IndexesFoldsPos = [];
    IndexesFoldsNeg = [];
    
    for fold = 1:Folds
        maxIndexRowTest = numRowsToTest * fold;
        URMTrain = [URM(1:maxIndexRowTest - numRowsToTest, :); URM(maxIndexRowTest + 1:end, :)];
        URMTest = URM(maxIndexRowTest - numRowsToTest + 1:maxIndexRowTest, :);
        
        Poss(fold) = PositiveTestSet(fold);
        Negg(fold) = NegativeTestSet(fold);
        
        LeaveOneOutPath = [ModelParameters.Path filesep 'Methods' filesep 'leaveOneOut'];
        addpath(LeaveOneOutPath);
        
        [PositiveResult, NegativeResult] = doMethod(Algorithm, URM, URMTrain, Poss, Negg, ModelParameters, OnLineParameters);
        
        IndexesFoldsPos(fold).begin = length(PositiveTests) + 1;
        IndexesFoldsNeg(fold).begin = length(NegativeTests) + 1;
        IndexesFoldsPos(fold).end = length(PositiveTests) + length(PositiveResult) - 1;
        IndexesFoldsNeg(fold).end = length(NegativeTests) + length(NegativeResult) - 1;
        PositiveTests = [PositiveTests PositiveResult];
        NegativeTests = [NegativeTests NegativeResult];
        
        rmpath(LeaveOneOutPath);
    end
    
    PositiveTestSet = Poss;
    NegativeTestSet = Negg;
    
    rmpath(PathUtility);
end