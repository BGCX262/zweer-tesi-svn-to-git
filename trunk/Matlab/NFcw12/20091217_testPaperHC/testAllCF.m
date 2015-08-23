function [] = testallCF (urm,percentageTest, profileLength)

%addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

folds = 10;

    tic
    
    [positiveTestsetReturn,negativeTestsetReturn]=extractTestSetsLongProfileUnpopular (urm,percentageTest,0,0,profileLength,folds,0);

%{
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,urm,1,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallTop, intervalBeginTop, intervalEndTop]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    fileName = [recallToprated_',mat2str(profileLength),'.mat'];
    save(fileName ,'recallTop');
	
    toc, tic
%}


%{
%%%%%%% SVD (sarwar)

    lss=[150, 300];

    fileName = ['recallSVD_',mat2str(profileLength),'.mat'];
    if fileExist(fileName) load(fileName); end
for i=1:length(lss)
    tic
    model.ls = lss(i)
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    eval([ '[recallSVD',num2str(lss(i)),', intervalBeginSVD',num2str(lss(i)),', intervalEndSVD,num2str(lss(i)),']=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos)' ]);    
    save(fileName,'recallSVD*');
    toc
end

%}

%%%%%%% COS

    knnn=[200];

    fileName = ['recallCOS_',mat2str(profileLength),'.mat'];
    if fileExist(fileName) load(fileName); end
for i=1:length(knnn)
    tic
    model.knn=knnn(i)
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn_test,urm,model,1,positiveTestsetReturn,negativeTestsetReturn);
    eval([ '[recallCOS',num2str(knnn(i)),', intervalBeginCOS',num2str(knnn(i)),', intervalEndCOS',num2str(knnn(i)),']=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos)' ]);
    save(fileName,'recallCOS*');
    toc
end



end