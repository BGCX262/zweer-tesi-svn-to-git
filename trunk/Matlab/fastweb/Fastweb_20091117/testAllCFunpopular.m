function [] = testAllCFunpopular (urm,percentageTest,unpopularThreshold)

%addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

folds = 10;
if (unpopularThreshold<1) 
    itemPivotPopular = findRatingPercentile(urm , unpopularThreshold);
    itemPivotPopularStr = num2str(unpopularThreshold);
    itemPivotPopularStr(strfind(itemPivotPopularStr ,'.'))='_';
else
    itemPivotPopular = unpopularThreshold;
    itemPivotPopularStr = num2str(itemPivotPopular);
end

display(['unpopular Threshold = ',num2str(itemPivotPopular )]);

[positiveTestsetReturn,negativeTestsetReturn]=extractTestSetsUnpopular(urm ,percentageTest,-1,itemPivotPopular,folds);


    tic

    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,urm,1,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallTopunpopular, intervalBeginTopunpopular, intervalEndTopunpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    save(['recallTopratedunpopular',itemPivotPopularStr],'recallTopunpopular');
	
    toc, tic

%%%%%%% SVD (sarwar)

    ls =5
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD5unpopular, intervalBeginSVD5unpopular, intervalEndSVD5unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic

    ls =15
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD15unpopular, intervalBeginSVD15unpopular, intervalEndSVD15unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
   
    toc, tic

    ls =25
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD25unpopular, intervalBeginSVD25unpopular, intervalEndSVD25unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    save('recallSVDtmpunpopular','recallSVD25unpopular','recallSVD15unpopular','recallSVD5unpopular');

    toc, tic	

    ls =50
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD50unpopular, intervalBeginSVD50unpopular, intervalEndSVD50unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic

    ls =100
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD100unpopular, intervalBeginSVD100unpopular, intervalEndSVD100unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic

    ls =150
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD150unpopular, intervalBeginSVD150unpopular, intervalEndSVD150unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    save(['recallSVDunpopular',itemPivotPopularStr],'recallSVD150unpopular','recallSVD100unpopular','recallSVD50unpopular','recallSVD25unpopular','recallSVD15unpopular','recallSVD5unpopular');
    delete('recallSVDtmpunpopular.mat');


%%%%%%%% COS

    toc, tic

    knn = 10
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos10unpopular, intervalBeginCos10unpopular, intervalEndCos10unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic

    knn = 50
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos50unpopular, intervalBeginCos50unpopular, intervalEndCos50unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    save('recallCosTmpunpopular','recallCos50unpopular', 'recallCos10unpopular');

    toc, tic

    knn = 100
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos100unpopular, intervalBeginCos100unpopular, intervalEndCos100unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic

    knn = 150
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos150unpopular, intervalBeginCos150unpopular, intervalEndCos150unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    save(['recallCosunpopular',itemPivotPopularStr],'recallCos150unpopular','recallCos100unpopular','recallCos50unpopular', 'recallCos10unpopular');
    delete('recallCosTmp.mat');


%%%%%%%%%%%% DR

    toc, tic

    knn = 10
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_drKNN', @createModel_drIIknn, @onLineRecom_drIIknn,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallDr10unpopular, intervalBeginDr10unpopular, intervalEndDr10unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic

    save('recallDrTmpunpopular','recallDr10unpopular');

    knn = 50
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_drKNN', @createModel_drIIknn, @onLineRecom_drIIknn,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallDr50unpopular, intervalBeginDr50unpopular, intervalEndDr50unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
   
    save('recallDrTmpunpopular','recallDr50unpopular', 'recallDr10unpopular');

    toc, tic

    knn = 100
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_drKNN', @createModel_drIIknn, @onLineRecom_drIIknn,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallDr100unpopular, intervalBeginDr100unpopular, intervalEndDr100unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic

    knn = 150
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_drKNN', @createModel_drIIknn, @onLineRecom_drIIknn,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallDr150unpopular, intervalBeginDr150unpopular, intervalEndDr150unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic

    knn = 200
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_drKNN', @createModel_drIIknn, @onLineRecom_drIIknn,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallDr200unpopular, intervalBeginDr200unpopular, intervalEndDr200unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    save(['recallDrunpopular',itemPivotPopularStr],'recallDr200unpopular','recallDr150unpopular','recallDr100unpopular','recallDr50unpopular', 'recallDr10unpopular');

    delete('recallDrTmpunpopular.mat');


    toc
end