function [] = testSVDcfUnpopular (urm,percentageTest,unpopularThreshold)

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
	
    fileName = ['recallSVDunpopular',itemPivotPopularStr,'.mat'];
    if fileExist(fileName) load(fileName); end

%%%%%%% SVD (sarwar)

    ls=200
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD200unpopular, intervalBeginSVD200unpopular, intervalEndSVD200unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic

    ls=300
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD300unpopular, intervalBeginSVD300unpopular, intervalEndSVD300unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
 
    toc
    save(fileName ,'recallSVD*');
end