function [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(k,algoPath, modelFunction, onLineFunction,urm,modelParam,onlineParam,positiveTestset,negativeTestset)
% [positiveTests,negativeTests,positiveTestset,negativeTestset]= 
%    kfolder(k,algoPath, modelFunction,
%       onLineFunction,urm,modelParam,onlineParam,positiveTestset,
%       negativeTestset)
% 
% - k = number of folder of the k-folder test
% - algoPath = path of algorithm functions
% - modelFunction and onLineFunction = algorithms functions (as @function)
% - urm = matrix users x items
% - positiveTestset = VECTOR OF positive testsets, i.e., the
% indexes of ratings (pairs of user-item) to test. testsetPath must contain
% two test set. They are computed by means of extractTestSets.m function
% and have a struct format. positiveTestset.i and positiveTestset.j are the
% row and column indeces. EACH ELEMENT (i) OF the vector refers to the i-th
% fold tested. 
% - negativeTestset
% - parameters of the algorithm (model and online) and of the metric. The
% format of each parameter is a struct

addpath(algoPath);

%popolarity=full(sum(spones(urm),1));

numUsers=size(urm,1);
numRowsToTest = floor(numUsers/k);

positiveTests=[];
negativeTests=[];
indexexOfFoldsPos=[];
indexexOfFoldsNeg=[];

for fold=1:k
%suddivido in parte di test (urmTest) e parte di train (urmTrain)

    maxIndexRowTest = numRowsToTest * fold;
   % urmTrain = [urm(1 : numRowsToTest * (fold-1) , :) ; urm((numRowsToTest * fold) + 1:end ,:)];
   % urmTest = urm(maxIndexRowTest - numRowsToTest + 1 : maxIndexRowTest , :);
    urmTrain = [urm(1 : maxIndexRowTest - numRowsToTest, :) ; urm(maxIndexRowTest + 1:end ,:)];
    urmTest = urm(maxIndexRowTest - numRowsToTest + 1 : maxIndexRowTest , :);
 
     if (exist('negativeTestset')==0)
        negativeTestset =-1;
    end
   
    if (isstruct(negativeTestset))
        poss=positiveTestset(fold);
        negg=negativeTestset(fold);
    else
        [poss,negg]=extractTestSets (urmTest,positiveTestset,negativeTestset);        
        poss.i=poss.i + maxIndexRowTest - numRowsToTest;
        negg.i=negg.i + maxIndexRowTest - numRowsToTest;
    end 
    pos(fold)=poss;
    neg(fold)=negg;
    
    if (~strcmp(class(modelFunction),'function_handle') || ~strcmp(class(onLineFunction),'function_handle'))
        positiveResult=0;
        negativeResult=0;
        indexexOfFoldsPos=0;
        indexexOfFoldsNeg=0;
        positiveTests=[positiveTests,positiveResult];
        negativeTests=[negativeTests,negativeResult];
        continue;
    end
    
    [positiveResult,negativeResult]=leaveOneOut(algoPath, modelFunction, onLineFunction,urm,urmTrain,poss,negg,modelParam,onlineParam);
    indexexOfFoldsPos(fold).begin=length(positiveTests)+1;
    indexexOfFoldsNeg(fold).begin=length(negativeTests)+1;
    indexexOfFoldsPos(fold).end=length(positiveTests)+length(positiveResult)-1;
    indexexOfFoldsNeg(fold).end=length(negativeTests)+length(negativeResult)-1;
    positiveTests=[positiveTests,positiveResult];
    negativeTests=[negativeTests,negativeResult];
    
%rmpath(algoPath);

end


positiveTestsetReturn=pos;
negativeTestsetReturn=neg;

end