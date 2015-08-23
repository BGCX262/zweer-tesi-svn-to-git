function [] = testKorenImplicit_expPercRank (urm,refday,intervalDays,totestDays,trainDays,testDays)
%% testKorenImplicit_expPercRank(urm,refday,intervalDays,totestDays,trainDays,testDays)
%
% This test applies a time-based hold-out methodology to urm .
% See "Collaborative Filtering for Implicit Feedback Datasets" 
% Yifan Hu, Yehuda Koren, Chris Volinsky [ICDM 2008]
%
% - urm = urm with timestamps
% - refday = reference day, eg '01/01/2000'
% - intervalDays = days included into the urm timestamps, referred to refday, eg [1:240]
% - totestDays = days to test, referred to refday, eg [192, 342]
% - trainDays = number of days to include in the training set, eg 28
% - testDays = number of days to include in the test set, eg 7
%
% eg,
% testAll_expPercRank(urmTS_170309,'07/04/2008',[1:346],[300,182],28,7);

%%
addpath('/home/turrin/matlab/coldstart/matlabCode');
addpath('/home/turrin/matlab/Engineering');
%%

%%
% addpath('D:\Documenti\University\work\recommenders\Cold Start\fw_urmTimestamp\matlabCode');
% addpath('D:\Documenti\University\work\recommenders\matlab\Engineering');
%%

format compact;

%%
for i=totestDays;
    tic;
    trainInterval = [i, i+trainDays];
    if (trainInterval(2)>max(intervalDays))
        continue;
    end
    testInterval = [trainInterval(2)+1, trainInterval(2)+1+testDays];
    if (testInterval(1)>max(intervalDays) || testInterval(2)>max(intervalDays))
        continue;
    end    
    
    display (['Train: ', num2str(trainInterval(1)), '-', num2str(trainInterval(2))]);
    display (['Test: ', num2str(testInterval(1)), '-', num2str(testInterval(2))]);

    urmTrain = generateURMfromTimestampFull(urm,datestr(addtodate(datenum(refday,'dd/mm/yyyy'),trainInterval(2),'day'),'dd/mm/yyyy'),datestr(addtodate(datenum(refday,'dd/mm/yyyy'),trainInterval(1),'day'),'dd/mm/yyyy'));
    urmTest = generateURMfromTimestampFull(urm,datestr(addtodate(datenum(refday,'dd/mm/yyyy'),testInterval(2),'day'),'dd/mm/yyyy'),datestr(addtodate(datenum(refday,'dd/mm/yyyy'),testInterval(1),'day'),'dd/mm/yyyy'));
    
    urmTotal=urmTrain+urmTest;
    activeUsers=find(sum(urmTotal,2));
    activeItems=find(sum(urmTotal,1));
    urmTrain=urmTrain(activeUsers,activeItems);
    urmTest=urmTest(activeUsers,activeItems);
    
%%  %%%%%%%%%%%%%%%%
    %% ATTENZIONE %%
    %%%%%%%%%%%%%%%%
    %
    % Gli item non esistenti durante la costruzione del modello vanno
    % rimossi dall'insieme di test perché non possono essere testati
    %
    itemsRef = sum(spones(urmTrain),1); %conta i rating di ciascun item
    urmTest(:,find(itemsRef==0))=0; %nella urm di test, azzera gli items non esistenti nel modello!
    %%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%
    % Gli user non esistenti durante la costruzione del modello vanno
    % rimossi dall'insieme di test per coerenza con il test proposto da Koren
    %
    usersRef = sum(spones(urmTrain),2); %conta i rating di ciascun user
    urmTest(find(usersRef ==0),:)=0; %nella urm di test, azzera gli utenti non esistenti nel modello!
    %%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%
%%
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolderTimeHoldOut(urmTrain,urmTest,'/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,1,1,1,-1);
    [expPercRankTop(i), intervalBeginTop(i), intervalEndTop(i)]=computeConfidenceExpPercRank(positiveTests,urmTest ,indexexOfFoldsPos);
%    save('expPercRankToprated','expPercRankTop','intervalBeginTop','intervalEndTop');  

    fileName=['expPercRankToprated_',num2str(trainDays),'_',num2str(testDays)];	
    save(fileName,'expPercRankTop');
%    save(strcat('testSet_',i), 'positiveTestsetReturn','negativeTestsetReturn');
    

    varName = ['testTop_',num2str(i)];
    eval([varName,'=positiveTests;']);    

%%
    model.ls=50;
    model.iter=20;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolderTimeHoldOut(urmTrain,urmTest,'/home/turrin/matlab/Engineering/KorenImplicit', @createModel_KorenImplicit, @onLineRecom_KorenImplicit,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [expPercRankKoren50iter20(i), intervalBeginKoren50iter20(i), intervalEndKoren50iter20(i)]=computeConfidenceExpPercRank(positiveTests,urmTest ,indexexOfFoldsPos);

    varName = ['testKorenImpl',num2str(model.ls),'iter',num2str(model.iter),'_',num2str(i)];
    eval([varName,'=positiveTests;']);

    fileName=['expPercRankKorenImpl_',num2str(trainDays),'_',num2str(testDays)];	
    save(fileName,'expPercRankKoren*');

%%
    ls =5
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolderTimeHoldOut(urmTrain,urmTest,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [expPercRankSVD5(i), intervalBeginSVD5(i), intervalEndSVD5(i)]=computeConfidenceExpPercRank(positiveTests,urmTest ,indexexOfFoldsPos);
    %save('expPercRankSVD5','expPercRankSVD5','intervalBeginSVD5','intervalEndSVD5','ls'); 

    varName = ['testSVD',num2str(ls),'_',num2str(i)];
    eval([varName,'=positiveTests;']);    
%%  
    ls =15
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolderTimeHoldOut(urmTrain,urmTest,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [expPercRankSVD15(i), intervalBeginSVD15(i), intervalEndSVD15(i)]=computeConfidenceExpPercRank(positiveTests,urmTest ,indexexOfFoldsPos);
    %save('expPercRankSVD15','expPercRankSVD15','intervalBeginSVD15','intervalEndSVD15','ls'); 

    varName = ['testSVD',num2str(ls),'_',num2str(i)];
    eval([varName,'=positiveTests;']); 

%%
    ls =25
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolderTimeHoldOut(urmTrain,urmTest,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [expPercRankSVD25(i), intervalBeginSVD25(i), intervalEndSVD25(i)]=computeConfidenceExpPercRank(positiveTests,urmTest ,indexexOfFoldsPos);
    %save('expPercRankSVD25','expPercRankSVD25','intervalBeginSVD25','intervalEndSVD25','ls'); 

    varName = ['testSVD',num2str(ls),'_',num2str(i)];
    eval([varName,'=positiveTests;']); 
    
%%    
    ls =50
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolderTimeHoldOut(urmTrain,urmTest,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [expPercRankSVD50(i), intervalBeginSVD50(i), intervalEndSVD50(i)]=computeConfidenceExpPercRank(positiveTests,urmTest ,indexexOfFoldsPos);
    %save('expPercRankSVD50','expPercRankSVD50','intervalBeginSVD50','intervalEndSVD50','ls'); 

    varName = ['testSVD',num2str(ls),'_',num2str(i)];
    eval([varName,'=positiveTests;']); 
    
%%    
    ls =100
    model.ls = ls;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolderTimeHoldOut(urmTrain,urmTest,'/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [expPercRankSVD100(i), intervalBeginSVD100(i), intervalEndSVD100(i)]=computeConfidenceExpPercRank(positiveTests,urmTest ,indexexOfFoldsPos);
    %save('expPercRankSVD100','expPercRankSVD100','intervalBeginSVD100','intervalEndSVD100','ls');     

    varName = ['testSVD',num2str(ls),'_',num2str(i)];
    eval([varName,'=positiveTests;']);     

%%
    fileName=['expPercRankSVD_',num2str(trainDays),'_',num2str(testDays)];	
    save(fileName,'expPercRankSVD*');

%%    
    knn = 10
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolderTimeHoldOut(urmTrain,urmTest,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [expPercRankCos10(i), intervalBeginCos10(i), intervalEndCos10(i)]=computeConfidenceExpPercRank(positiveTests,urmTest ,indexexOfFoldsPos);
    %save('expPercRankCos10','expPercRankCos10','intervalBeginCos10','intervalEndCos10');  

    varName = ['testCOS',num2str(knn),'_',num2str(i)];
    eval([varName,'=positiveTests;']); 
    
%%    
    knn = 50
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolderTimeHoldOut(urmTrain,urmTest,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [expPercRankCos50(i), intervalBeginCos50(i), intervalEndCos50(i)]=computeConfidenceExpPercRank(positiveTests,urmTest ,indexexOfFoldsPos);
    %save('expPercRankCos50','expPercRankCos50','intervalBeginCos50','intervalEndCos50');  

    varName = ['testCOS',num2str(knn),'_',num2str(i)];
    eval([varName,'=positiveTests;']); 

%%    
    knn = 100
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolderTimeHoldOut(urmTrain,urmTest,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [expPercRankCos100(i), intervalBeginCos100(i), intervalEndCos100(i)]=computeConfidenceExpPercRank(positiveTests,urmTest ,indexexOfFoldsPos);
    %save('expPercRankCos100','expPercRankCos100','intervalBeginCos100','intervalEndCos100');  

    varName = ['testCOS',num2str(knn),'_',num2str(i)];
    eval([varName,'=positiveTests;']); 
    
%%    
    knn = 150
    model.knn=knn;
    [positiveTests,negativeTests,positiveTestsetReturn,negativeTestsetReturn,indexexOfFoldsPos,indexexOfFoldsNeg]=kfolderTimeHoldOut(urmTrain,urmTest,'/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,model,1,positiveTestsetReturn,negativeTestsetReturn);
    [expPercRankCos150(i), intervalBeginCos150(i), intervalEndCos150(i)]=computeConfidenceExpPercRank(positiveTests,urmTest ,indexexOfFoldsPos);
    %save('expPercRankCos150','expPercRankCos150','intervalBeginCos150','intervalEndCos150');

    varName = ['testCOS',num2str(knn),'_',num2str(i)];
    eval([varName,'=positiveTests;']); 
    
%%    
    
    fileName=['expPercRankCos_',num2str(trainDays),'_',num2str(testDays)];
    save(fileName,'expPercRankCos*');

    fileName=['test_',num2str(trainDays),'_',num2str(testDays)];
    save(fileName,'test*');
    
    toc
end