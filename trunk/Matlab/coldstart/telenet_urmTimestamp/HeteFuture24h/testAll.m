function [] = testAll (days,numGiorniTest,urm,daysToJump)

addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
%%addpath('D:\Documenti\University\work\recommenders\Cold Start\fw_urmTimestamp\matlabCode');
addpath('/home/turrin/matlab/Engineering');

%folds = 10;

%[positiveTests,negativeTests]=
%       leaveOneOut(algoPath, modelFunction, onLineFunction,urm,urmTrain,positiveTestset,negativeTestset,modelParam,onlineParam)
%[positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=
%       kfolder(k,algoPath, modelFunction, onLineFunction,urm,modelParam,onlineParam,positiveTestset,negativeTestset)

%%[r,c]=sort(urm(:,3));
%%urmSorted=urm(c,:);


format compact
for j=1:length(days)
    prev=days(j);
    day = prev+numGiorniTest;
    if ( (prev<=min(daysToJump)) & (day>=min(daysToJump)) )	
	  day=day+(max(daysToJump)-min(daysToJump)-1);
    end
    if (day>max(days))
       continue;
    end

    trainURM = generateURMfromTimestampFull(urm,datestr(addtodate(datenum('01/03/2008','dd/mm/yyyy'),+prev,'day'),'dd/mm/yyyy')); %A(t_0)
    actualURM = generateURMfromTimestampCompactUsersItemsFull(urm,datestr(addtodate(datenum('01/03/2008','dd/mm/yyyy'),+day,'day'),'dd/mm/yyyy'),datestr(addtodate(datenum('01/03/2008','dd/mm/yyyy'),+prev,'day'),'dd/mm/yyyy')); %A(t) 
    
   j,prev,day

    tic;
    diffURM=spones(actualURM)-spones(trainURM);    %A(t) \ A(t_0)
    [positiveTestset,negativeTestset]=extractTestSets (diffURM,1,-1);
    save(strcat('testSet_',num2str(prev)), 'positiveTestset','negativeTestset');
    
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,trainURM ,trainURM,positiveTestset,negativeTestset,1,1);
    %%[positiveTests,negativeTests]=leaveOneOut('D:\Documenti\University\work\recommenders\matlab\Engineering\topRated', @createModel_toprated, @onLineRecom_toprated,actualURM,trainURM,positiveTestset,negativeTestset,1,1);
    [recallTop(prev)]=computeRecall(positiveTests,5);
    save('recallToprated','recallTop');  


    
    
    model.ls = 15;
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,trainURM ,trainURM,positiveTestset,negativeTestset,model,1);
    [recallSVD15(prev)]=computeRecall(positiveTests,5);
%    save('recallSVD15','recallSVD15'); 

    model.ls = 25;
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,trainURM ,trainURM,positiveTestset,negativeTestset,model,1);
    [recallSVD25(prev)]=computeRecall(positiveTests,5);
%    save('recallSVD25','recallSVD25'); 
	
    model.ls = 50;
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,trainURM ,trainURM,positiveTestset,negativeTestset,model,1);
    [recallSVD50(prev)]=computeRecall(positiveTests,5);
%    save('recallSVD50','recallSVD50'); 

    model.ls = 100;
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,trainURM ,trainURM,positiveTestset,negativeTestset,model,1);
    [recallSVD100(prev)]=computeRecall(positiveTests,5);
%    save('recallSVD100','recallSVD100'); 

    save('recallSVD','recallSVD100','recallSVD50','recallSVD25','recallSVD15');

    model.knn=10;
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,trainURM ,trainURM,positiveTestset,negativeTestset,model,1);
    [recallCos10(prev)]=computeRecall(positiveTests,5);
%    save('recallCos10','recallCos10');  

    model.knn=50;
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,trainURM ,trainURM,positiveTestset,negativeTestset,model,1);
    [recallCos50(prev)]=computeRecall(positiveTests,5);
%    save('recallCos50','recallCos50');  

    model.knn=100;
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,trainURM ,trainURM,positiveTestset,negativeTestset,model,1);
    [recallCos100(prev)]=computeRecall(positiveTests,5);
%    save('recallCos100','recallCos100');  

    save('recallCos','recallCos100','recallCos50', 'recallCos10');

    toc
end