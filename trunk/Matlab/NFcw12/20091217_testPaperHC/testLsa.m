function [] = testLsa (urm,icmItemModel,percentageTest,profileLength)
% [] = testLsa (urm,icmItemModel,percentageTest,profileLength)

%addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

    fileName = ['recallLSA_',mat2str(profileLength),'.mat'];
    if fileExist(fileName) load(fileName); end

    folds = 10;

    [positiveTestsetReturn,negativeTestsetReturn]=extractTestSetsLongProfileUnpopular (urm,percentageTest,0,0,profileLength,folds,0);
    model.itemModel = icmItemModel;
    
    tic
	
    lsLSA = 150
    model.ls=lsLSA;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallLSA150, intervalBeginLsa150, intervalEndLsa150]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic
    save(fileName,'recallLSA*');

    lsLSA = 300
    model.ls=lsLSA;
   [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallLSA300, intervalBeginLSA300, intervalEndLSA300]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    save(fileName,'recallLSA*');

    toc

end