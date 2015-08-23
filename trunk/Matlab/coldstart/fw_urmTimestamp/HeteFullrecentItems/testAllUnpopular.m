function [] = testAllUnpopular (refday,days,urm,unpopularThreshold,append)
% testAllUnpopular (refday,days,urm,unpopularThreshold,append)

addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

folds = 10;

j=1;


%%%%%%%%% begin RIMUOVERE %%%%%%%%%%%
%%%%%%%%%%%%load recallSVDUnpopular50p
%%%%%%%%% end DA RIMUOVERE %%%%%%%%%%%

if (nargin<5)
   append = false;
end
if (append && (unpopularThreshold<1 || length(unpopularThreshold)==1)) 
    if (unpopularThreshold<1)
        itemPivotPopularStr = num2str(unpopularThreshold(j));
        itemPivotPopularStr(strfind(itemPivotPopularStr ,'.'))='_';
    else
        itemPivotPopular = unpopularThreshold(j);
	    itemPivotPopularStr = num2str(itemPivotPopular);
    end
    fileName = ['recallTopratedunpopular',itemPivotPopularStr,'.mat']
    if fileExist(fileName) load(fileName); end
    fileName = ['recallSVDUnpopular',itemPivotPopularStr,'.mat'];
    if fileExist(fileName) load(fileName); end
    fileName = ['recallCosUnpopular',itemPivotPopularStr,'.mat'];
    if fileExist(fileName) load(fileName); end
end



for i=days;
    tic;
    i
	
    actualURM = generateURMfromTimestamp(urm,datestr(addtodate(datenum(refday,'dd/mm/yyyy'),+i,'day'),'dd/mm/yyyy'));
    if (unpopularThreshold<1) 
	    itemPivotPopular = findRatingPercentile(actualURM , unpopularThreshold(j));
	    itemPivotPopularStr = num2str(unpopularThreshold(j));
	    itemPivotPopularStr(strfind(itemPivotPopularStr ,'.'))='_';
    else
	    itemPivotPopular = unpopularThreshold(j);
	    itemPivotPopularStr = num2str(itemPivotPopular);
    end
    [positiveTestsetReturn,negativeTestsetReturn]=extractTestSetsUnpopular(actualURM ,0.5,-1,itemPivotPopular,folds);	

    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,actualURM,1,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallTopUnpopular(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos)
    save(['recallTopratedunpopular',itemPivotPopularStr],'recallTopUnpopular');  


%%%%%%%%% begin RIMUOVERE %%%%%%%%%%%
%ls =150
%model.ls = ls;
%[positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
%[recallSVD150unpopular(i), intervalBeginSVD150(i), intervalEndSVD150(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
%
%save('recallSVDUnpopular50p','recallSVD5unpopular','recallSVD15unpopular','recallSVD25unpopular','recallSVD50unpopular','recallSVD100unpopular', 'recallSVD150unpopular');
%
%continue;
%
%%%%%%%%% end DA RIMUOVERE %%%%%%%%%%%


    %save(strcat('testSet_',i), 'positiveTestsetReturn','negativeTestsetReturn');


    ls =5
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD5unpopular(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos)


    ls =15
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD15unpopular(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos)

    ls =25
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD25unpopular(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos)
	
    ls =50
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD50unpopular(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos)

    ls =100
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD100unpopular(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos)

    ls =150
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD150unpopular(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos)

    save(['recallSVDUnpopular',itemPivotPopularStr],'recallSVD5unpopular','recallSVD15unpopular','recallSVD25unpopular','recallSVD50unpopular','recallSVD100unpopular', 'recallSVD150unpopular');

    knn = 10
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos10unpopular(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos)

    knn = 50
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos50unpopular(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos)

    knn = 100
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos100unpopular(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos)

    knn = 150
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallCos150unpopular(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos)
    save(['recallCosUnpopular',itemPivotPopularStr],'recallCos10unpopular','recallCos50unpopular','recallCos100unpopular','recallCos150unpopular');  

    if length(unpopularThreshold)>1 
	   j=j+1;
    end

    toc
end

end


function [statusFile] = fileExist (fileName)
    if (exist(fileName,'file'))
        display(['loaded ', fileName]);
        statusFile=true;
    else
	   display([fileName,' not exist']);
       statusFile=false;
    end
end