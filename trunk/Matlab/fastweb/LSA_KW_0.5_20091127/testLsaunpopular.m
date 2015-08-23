function [] = testLsaunpopular (urm,icmItemModel,percentageTest,unpopularThreshold)

%addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

folds = 10;

    tic
	
    model.itemModel = icmItemModel;

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


    lsLSA = 50
    model.ls=lsLSA;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallLSA50unpopular, intervalBeginLsa50unpopular, intervalEndLsa50unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic
    save('recallLSATmpunpopular','recallLSA50unpopular');

    lsLSA = 100
    model.ls=lsLSA;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallLSA100unpopular, intervalBeginLsa100unpopular, intervalEndLsa100unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic
    save('recallLSATmpunpopular','recallLSA50unpopular','recallLSA100unpopular');

    lsLSA = 150
    model.ls=lsLSA;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallLSA150unpopular, intervalBeginLsa150unpopular, intervalEndLsa150unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic
    save('recallLSATmpunpopular','recallLSA50unpopular','recallLSA100unpopular','recallLSA150unpopular');

    lsLSA = 200
    model.ls=lsLSA;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallLSA200unpopular, intervalBeginLsa200unpopular, intervalEndLsa200unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    toc, tic
    save('recallLSATmpunpopular','recallLSA50unpopular','recallLSA100unpopular','recallLSA150unpopular','recallLSA200unpopular');

    lsLSA = 300
    model.ls=lsLSA;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallLSA300unpopular, intervalBeginLSA300unpopular, intervalEndLSA300unpopular]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    save(['recallLSAunpopular',itemPivotPopularStr],'recallLSA50unpopular','recallLSA100unpopular','recallLSA150unpopular','recallLSA200unpopular','recallLSA300unpopular');
    delete('recallLSATmpunpopular.mat');

    toc

end