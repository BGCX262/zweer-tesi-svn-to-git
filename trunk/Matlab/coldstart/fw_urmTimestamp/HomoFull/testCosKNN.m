function [] = testCosKNN (days,knn,urm,posTestSet,negTestSet,savefilename)

addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

folds = length(posTestSet);
model.knn=knn;

for i=days;
    tic;
    i
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,generateURMfromTimestamp(urm,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),-i,'day'),'dd/mm/yyyy')),model,1,posTestSet,negTestSet);
    [recallCos(i), intervalBeginCos(i), intervalEndCos(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save(savefilename,'recallCos','intervalBeginCos','intervalEndCos');  
    toc
end