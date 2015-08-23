function [] = testLsa (urm,icmItemModel,percentageTest)
% [] = testLsa (urm,icmItemModel,percentageTest)

%addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

    fileName = 'recallLSA.mat';
    if fileExist(fileName) load(fileName); end

folds = 10;

    tic
	
    model.itemModel = icmItemModel;

    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,urm,1,1,percentageTest,-1);

    lsLSA = 50
    model.ls=lsLSA;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallLSA50, intervalBeginLsa50, intervalEndLsa50]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic
    save('recallLSATmp','recallLSA50');

    lsLSA = 100
    model.ls=lsLSA;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallLSA100, intervalBeginLsa100, intervalEndLsa100]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic
    save('recallLSATmp','recallLSA50','recallLSA100');

    lsLSA = 150
    model.ls=lsLSA;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallLSA150, intervalBeginLsa150, intervalEndLsa150]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

%    toc, tic
%    save('recallLSATmp','recallLSA50','recallLSA100','recallLSA150');
%
%    lsLSA = 200
%    model.ls=lsLSA;
%    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
%    [recallLSA200, intervalBeginLsa200, intervalEndLsa200]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
%
%    toc, tic
%    save('recallLSATmp','recallLSA50','recallLSA100','recallLSA150','recallLSA200');
%
%    lsLSA = 300
%    model.ls=lsLSA;
%   [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
%    [recallLSA300, intervalBeginLSA300, intervalEndLSA300]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
%
%    save('recallLSA','recallLSA50','recallLSA100','recallLSA150','recallLSA200','recallLSA300');
 save('recallLSA','recallLSA50','recallLSA100','recallLSA150');

%    delete('recallLSATmp.mat');

    toc

end