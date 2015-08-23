function [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolderTimeHoldOut(urmTrain,urmTest,algoPath, modelFunction, onLineFunction,modelParam,onlineParam,positiveTestset,negativeTestset)
%[positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,
%  indexexOfFoldsNeg]=kfolderTimeHoldOut(urmTrain,urmTest,
%  algoPath, modelFunction, onLineFunction,modelParam,onlineParam,
%  positiveTestset,negativeTestset)
%
% - urmTrain = generateURMfromTimestampFull(urmTS_170309,'31/10/2008','01/01/2000'); 
%              NB: note the order of the called function parameters!!
% - urmTest = generateURMfromTimestampFull(urmTS_170309,'30/11/2008','01/11/2008'); 
%              NB: note the order of the called function parameters!!
% - algoPath = path of algorithm functions
% - modelFunction and onLineFunction = algorithms functions (as @function)
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

    positiveTests=[];
    negativeTests=[];
    indexexOfFoldsPos=[];
    indexexOfFoldsNeg=[];


%    urmTrain = generateURMfromTimestampFull(urmTS, modelTSinterval(2,:),modelTSinterval(1,:));
%    urmTest = generateURMfromTimestampFull(urmTS, testSetTSinterval(2,:),testSetTSinterval(1,:));

    if (isstruct(negativeTestset))
        pos=positiveTestset;
        neg=negativeTestset;
    else
        [pos,neg]=extractTestSets(spones(urmTest),positiveTestset,negativeTestset);
    end 

            
    
    [positiveResult,negativeResult]=holdOut(algoPath, modelFunction, onLineFunction,urmTest+urmTrain,urmTrain,pos,neg,modelParam,onlineParam);

    positiveTestsetReturn=pos;
    negativeTestsetReturn=neg;
    
    positiveTests=positiveResult;
    negativeTests=negativeResult;

end