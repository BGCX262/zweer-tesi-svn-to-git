function [] = testToprated (days,urm,posTestSet,negTestSet,savefilename)

addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

folds = length(posTestSet);

ext='Toprated';

for i=days;
    tic;
    i
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,generateURMfromTimestamp(urm,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),-i,'day'),'dd/mm/yyyy')),1,1,posTestSet,negTestSet);
    [recall(i), intervalBegin(i), intervalEnd(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save(savefilename,'recall','intervalBegin','intervalEnd');  
    toc
end