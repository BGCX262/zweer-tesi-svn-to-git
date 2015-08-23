function [] = testSVDcf (urm,percentageTest)

%addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

folds = 10;

    tic
	
    fileName = 'recallSVD.mat';
    if fileExist(fileName) load(fileName); end

    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,urm,1,1,percentageTest,-1);

%%%%%%% SVD (sarwar)

    ls=200
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD200, intervalBeginSVD200, intervalEndSVD200]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic

    ls=300
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD300, intervalBeginSVD300, intervalEndSVD300]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
 
    toc
    save(fileName ,'recallSVD*');
end