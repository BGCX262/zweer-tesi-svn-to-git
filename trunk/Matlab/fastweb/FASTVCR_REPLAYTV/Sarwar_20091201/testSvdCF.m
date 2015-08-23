function [] = testSvdCF (urmTrain,urmTest,itemsToKeep,percentageTest)

%addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

folds = 10;
urm=urmTrain;

fileName = 'recallSVD.mat';
if fileExist(fileName) load(fileName); end

onlineParam.itemsToKeep=itemsToKeep;
onlineParam.postProcessingFunction=@filterItems;
[positiveTestsetReturn,negativeTestsetReturn]=extractTestSetsUnpopular (urmTest,percentageTest,-1,0,folds);


%%%%%%% SVD (sarwar)

  if (~exist('recallSVD5'))

    ls =5
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD5, intervalBeginSVD5, intervalEndSVD5]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallSVDtmp','recallSVD*');
    toc, tic
  end

  if (~exist('recallSVD15'))
    ls =15
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD15, intervalBeginSVD15, intervalEndSVD15]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallSVDtmp','recallSVD*');
    toc, tic
  end

  if (~exist('recallSVD25'))
    ls =25
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD25, intervalBeginSVD25, intervalEndSVD25]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallSVDtmp','recallSVD*');
    toc, tic
  end

  if (~exist('recallSVD50'))
    ls =50
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD50, intervalBeginSVD50, intervalEndSVD50]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallSVDtmp','recallSVD*');
    toc, tic
  end

  if (~exist('recallSVD100'))
    ls =100
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD100, intervalBeginSVD100, intervalEndSVD100]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallSVDtmp','recallSVD*');
    toc, tic
  end

  if (~exist('recallSVD150'))
    ls =150
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD150, intervalBeginSVD150, intervalEndSVD150]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallSVDtmp','recallSVD*');
    toc, tic
  end    

  if (~exist('recallSVD200'))
    ls =200
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD200, intervalBeginSVD200, intervalEndSVD200]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallSVDtmp','recallSVD*');
    toc, tic
  end   

  if (~exist('recallSVD300'))
    ls =300
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD300, intervalBeginSVD300, intervalEndSVD300]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallSVDtmp','recallSVD*');
    toc, tic
  end   


    save('recallSVD','recallSVD300','recallSVD200','recallSVD150','recallSVD100','recallSVD50','recallSVD25','recallSVD15','recallSVD5');
    delete('recallSVDtmp.mat');
end