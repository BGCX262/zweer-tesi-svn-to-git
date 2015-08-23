function [] = testLongProfile (days,urm,profilesLength)

addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

folds = 10;

j=0;

for i=days;
    tic;
    i

	if (length(profilesLength)>1) 
		j=j+1;
		profileLength=profilesLength(j);
	else
		profileLength=profilesLength;
	end
	
    actualURM = generateURMfromTimestamp(urm,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),+i,'day'),'dd/mm/yyyy'));
    [positiveTestsetReturn,negativeTestsetReturn]=extractTestSetsLongProfile(actualURM ,0.5,-1,profileLength,folds);

    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,actualURM,1,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallTopLongProfile10(i), intervalBeginTop(i), intervalEndTop(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallTopratedLongProfile10','recallTopLongProfile10');  




    ls =5
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD5LongProfile10(i), intervalBeginSVD5(i), intervalEndSVD5(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);


    ls =15
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD15LongProfile10(i), intervalBeginSVD15(i), intervalEndSVD15(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    ls =25
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD25LongProfile10(i), intervalBeginSVD25(i), intervalEndSVD25(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
	
    ls =50
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD50LongProfile10(i), intervalBeginSVD50(i), intervalEndSVD50(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    ls =100
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD100LongProfile10(i), intervalBeginSVD100(i), intervalEndSVD100(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    ls =150
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD150LongProfile10(i), intervalBeginSVD150(i), intervalEndSVD150(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    save('recallSVDLongProfile10','recallSVD5LongProfile10','recallSVD15LongProfile10','recallSVD25LongProfile10','recallSVD50LongProfile10','recallSVD100LongProfile10', 'recallSVD150LongProfile10');

    knn = 10
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos10LongProfile10(i), intervalBeginCos10(i), intervalEndCos10(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    knn = 50
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos50LongProfile10(i), intervalBeginCos50(i), intervalEndCos50(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    knn = 100
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos100LongProfile10(i), intervalBeginCos100(i), intervalEndCos100(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);

    knn = 150
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos150LongProfile10(i), intervalBeginCos150(i), intervalEndCos150(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    save('recallCosLongProfile10','recallCos10LongProfile10','recallCos50LongProfile10','recallCos100LongProfile10','recallCos150LongProfile10');  

    toc
end