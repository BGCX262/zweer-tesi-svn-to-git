function [] = testAllCF (urmTrain,urmTest,itemsToKeep,percentageTest)

%addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

folds = 10;
urm=urmTrain;

onlineParam.itemsToKeep=itemsToKeep;
onlineParam.postProcessingFunction=@filterItems;
[positiveTestsetReturn,negativeTestsetReturn]=extractTestSetsUnpopular (urmTest,percentageTest,-1,0,folds);


    tic

    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,urm,1,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallTop, intervalBeginTop, intervalEndTop]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    save('recallToprated2','recallTop');
	
    toc, tic

%%%%%%% SVD (sarwar)

    ls =5
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD5, intervalBeginSVD5, intervalEndSVD5]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallSVD5','recallSVD5','intervalBeginSVD5','intervalEndSVD5','ls'); 

    toc, tic

    ls =15
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD15, intervalBeginSVD15, intervalEndSVD15]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallSVD15','recallSVD15','intervalBeginSVD15','intervalEndSVD15','ls'); 

    toc, tic

    ls =25
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD25, intervalBeginSVD25, intervalEndSVD25]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallSVD25','recallSVD25','intervalBeginSVD25','intervalEndSVD25','ls'); 

    save('recallSVDtmp2','recallSVD25','recallSVD15','recallSVD5');

    toc, tic	

    ls =50
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD50, intervalBeginSVD50, intervalEndSVD50]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallSVD50','recallSVD50','intervalBeginSVD50','intervalEndSVD50','ls'); 

    toc, tic

    ls =100
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD100, intervalBeginSVD100, intervalEndSVD100]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallSVD100','recallSVD100','intervalBeginSVD100','intervalEndSVD100','ls');     

    toc, tic

    ls =150
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD150, intervalBeginSVD150, intervalEndSVD150]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallSVD150','recallSVD150','intervalBeginSVD150','intervalEndSVD150','ls');     

    save('recallSVD2','recallSVD150','recallSVD100','recallSVD50','recallSVD25','recallSVD15','recallSVD5');
    delete('recallSVDtmp2.mat');


%%%%%%%% COS

    toc, tic

    knn = 10
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos10, intervalBeginCos10, intervalEndCos10]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallCos10','recallCos10','intervalBeginCos10','intervalEndCos10');  

    toc, tic

    knn = 50
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos50, intervalBeginCos50, intervalEndCos50]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallCos50','recallCos50','intervalBeginCos50','intervalEndCos50');  

    save('recallCosTmp2','recallCos50', 'recallCos10');

    toc, tic

    knn = 100
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos100, intervalBeginCos100, intervalEndCos100]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallCos100','recallCos100','intervalBeginCos100','intervalEndCos100');  

    toc, tic

    knn = 150
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos150, intervalBeginCos150, intervalEndCos150]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallCos150','recallCos150','intervalBeginCos150','intervalEndCos150');

    save('recallCos2','recallCos150','recallCos100','recallCos50', 'recallCos10');
    delete('recallCosTmp2.mat');


%%%%%%%%%%%% DR

    toc, tic

    knn = 10
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_drKNN', @createModel_drIIknn, @onLineRecom_drIIknn,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallDr10, intervalBeginDr10, intervalEndDr10]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallDr10','recallDr10','intervalBeginDr10','intervalEndDr10');  

    toc, tic

    save('recallDrTmp2','recallDr10');

    knn = 50
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_drKNN', @createModel_drIIknn, @onLineRecom_drIIknn,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallDr50, intervalBeginDr50, intervalEndDr50]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallDr50','recallDr50','intervalBeginDr50','intervalEndDr50');  

    save('recallDrTmp2','recallDr50', 'recallDr10');

    toc, tic

    knn = 100
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_drKNN', @createModel_drIIknn, @onLineRecom_drIIknn,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallDr100, intervalBeginDr100, intervalEndDr100]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallDr100','recallDr100','intervalBeginDr100','intervalEndDr100');  

    toc, tic

    knn = 150
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_drKNN', @createModel_drIIknn, @onLineRecom_drIIknn,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallDr150, intervalBeginDr150, intervalEndDr150]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallDr150','recallDr150','intervalBeginDr150','intervalEndDr150');

    save('recallDr2','recallDr150','recallDr100','recallDr50', 'recallDr10');

    toc, tic

    knn = 200
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_drKNN', @createModel_drIIknn, @onLineRecom_drIIknn,urm,model,onlineParam,positiveTestsetReturn,negativeTestsetReturn);
    [recallDr200, intervalBeginDr200, intervalEndDr200]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    save('recallDr2','recallDr200','recallDr150','recallDr100','recallDr50', 'recallDr10');

    delete('recallDrTmp2.mat');


    toc
end