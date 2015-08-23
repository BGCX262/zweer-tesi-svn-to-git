function [] = testSVD (days,ls,urm,posTestSet,negTestSet,savefilename)

addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

model.ls=ls;

folds = length(posTestSet);

for i=days;
    tic;
    i
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,generateURMfromTimestamp(urm,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),-i,'day'),'dd/mm/yyyy')),model,1,posTestSet,negTestSet);
    [recall(i), intervalBegin(i), intervalEnd(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save(savefilename,'recall','intervalBegin','intervalEnd','ls'); 
    toc
end