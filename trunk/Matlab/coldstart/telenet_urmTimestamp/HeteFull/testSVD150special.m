function [] = testSVD150special(refday,days,urm,append)
%function [] = testSVD150special(refday,days,urm,append)

addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath('/home/turrin/matlab/Engineering');

folds = 10;
if (nargin<4)
   append = false;
end
if (append) 
    fileName = ['recallSVD','.mat'];
    if fileExist(fileName) load(fileName); end
end


for i=days;
    tic;
    i

    actualURM = generateURMfromTimestamp(urm,datestr(addtodate(datenum(refday,'dd/mm/yyyy'),+i,'day'),'dd/mm/yyyy'));


    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,actualURM,1,1,0.05,-1);

    ls =150
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolder(folds,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,actualURM,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [recallSVD150(i), intervalBeginSVD150(i), intervalEndSVD150(i)]=computeConfidenceRecall(positiveTests,5,indexexOfFoldsPos);
    %save('recallSVD150','recallSVD150','intervalBeginSVD150','intervalEndSVD100','ls');     

    save('recallSVD','recallSVD100','recallSVD50','recallSVD25','recallSVD15','recallSVD150');


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