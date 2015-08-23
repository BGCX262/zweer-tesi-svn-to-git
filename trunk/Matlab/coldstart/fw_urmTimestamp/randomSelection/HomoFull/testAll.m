function [] = testAll (urm,days)


folds = 10;
[positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn]=kfolder(folds,'/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,generateURMfromTimestamp(urm,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),-175,'day'),'dd/mm/yyyy')),1,1,1,-1);

save('testSet', 'positiveTestsetReturn','negativeTestsetReturn');

for i=days;
    tic;
    i
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,generateURMfromTimestamp(urm,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),-i,'day'),'dd/mm/yyyy')),1,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallTop(i), intervalBeginTop(i), intervalEndTop(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallToprated','recallTop','intervalBeginTop','intervalEndTop');  

    ls =15
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,generateURMfromTimestamp(urm,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),-i,'day'),'dd/mm/yyyy')),model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD15(i), intervalBeginSVD15(i), intervalEndSVD15(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallSVD15','recallSVD15','intervalBeginSVD15','intervalEndSVD15','ls'); 

    ls =25
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,generateURMfromTimestamp(urm,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),-i,'day'),'dd/mm/yyyy')),model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD25(i), intervalBeginSVD25(i), intervalEndSVD25(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallSVD25','recallSVD25','intervalBeginSVD25','intervalEndSVD25','ls'); 
	
    ls =50
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,generateURMfromTimestamp(urm,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),-i,'day'),'dd/mm/yyyy')),model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD50(i), intervalBeginSVD50(i), intervalEndSVD50(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallSVD50','recallSVD50','intervalBeginSVD50','intervalEndSVD50','ls'); 

    ls =100
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,generateURMfromTimestamp(urm,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),-i,'day'),'dd/mm/yyyy')),model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD100(i), intervalBeginSVD100(i), intervalEndSVD100(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallSVD100','recallSVD100','intervalBeginSVD100','intervalEndSVD100','ls');     

    knn = 10
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,generateURMfromTimestamp(urm,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),-i,'day'),'dd/mm/yyyy')),model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos10(i), intervalBeginCos10(i), intervalEndCos10(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallCos10','recallCos10','intervalBeginCos10','intervalEndCos10');  

    knn = 50
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,generateURMfromTimestamp(urm,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),-i,'day'),'dd/mm/yyyy')),model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos50(i), intervalBeginCos50(i), intervalEndCos50(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallCos50','recallCos50','intervalBeginCos50','intervalEndCos50');  

    knn = 100
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,generateURMfromTimestamp(urm,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),-i,'day'),'dd/mm/yyyy')),model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos100(i), intervalBeginCos100(i), intervalEndCos100(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallCos100','recallCos100','intervalBeginCos100','intervalEndCos100');  

    toc
end

