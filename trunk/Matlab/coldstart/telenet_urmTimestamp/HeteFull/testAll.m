function [] = testAll (refday,days,urm,append)
%function [] = testAll (refday,days,urm,append)

addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

folds = 10;
if (nargin<4)
   append = false;
end
if (append) 
    fileName = ['recallToprated','.mat']
    if fileExist(fileName) load(fileName); end
    fileName = ['recallSVD','.mat'];
    if fileExist(fileName) load(fileName); end
    fileName = ['recallCos','.mat'];
    if fileExist(fileName) load(fileName); end
end


for i=days;
    tic;
    i

    actualURM = generateURMfromTimestamp(urm,datestr(addtodate(datenum(refday,'dd/mm/yyyy'),+i,'day'),'dd/mm/yyyy'));


    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,actualURM,1,1,0.05,-1);
    [recallTop(i), intervalBeginTop(i), intervalEndTop(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
%    save('recallToprated','recallTop','intervalBeginTop','intervalEndTop');  

    save('recallToprated','recallTop');
%    save(strcat('testSet_',i), 'positiveTestsetReturn','negativeTestsetReturn');


    ls =5
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD5(i), intervalBeginSVD5(i), intervalEndSVD5(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallSVD5','recallSVD5','intervalBeginSVD5','intervalEndSVD5','ls'); 

%% DA RIMUOVERE %%
%    continue
%% %%%%%%%%%%%%%%%


    ls =15
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD15(i), intervalBeginSVD15(i), intervalEndSVD15(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallSVD15','recallSVD15','intervalBeginSVD15','intervalEndSVD15','ls'); 

    ls =25
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD25(i), intervalBeginSVD25(i), intervalEndSVD25(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallSVD25','recallSVD25','intervalBeginSVD25','intervalEndSVD25','ls'); 
	
    ls =50
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD50(i), intervalBeginSVD50(i), intervalEndSVD50(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallSVD50','recallSVD50','intervalBeginSVD50','intervalEndSVD50','ls'); 

    ls =100
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD100(i), intervalBeginSVD100(i), intervalEndSVD100(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallSVD100','recallSVD100','intervalBeginSVD100','intervalEndSVD100','ls');     

    save('recallSVD','recallSVD100','recallSVD50','recallSVD25','recallSVD15');

    knn = 10
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos10(i), intervalBeginCos10(i), intervalEndCos10(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallCos10','recallCos10','intervalBeginCos10','intervalEndCos10');  

    knn = 50
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos50(i), intervalBeginCos50(i), intervalEndCos50(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallCos50','recallCos50','intervalBeginCos50','intervalEndCos50');  

    knn = 100
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos100(i), intervalBeginCos100(i), intervalEndCos100(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallCos100','recallCos100','intervalBeginCos100','intervalEndCos100');  

    knn = 150
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos150(i), intervalBeginCos150(i), intervalEndCos150(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallCos150','recallCos150','intervalBeginCos150','intervalEndCos150');

    save('recallCos','recallCos100','recallCos50', 'recallCos10');

    toc
end