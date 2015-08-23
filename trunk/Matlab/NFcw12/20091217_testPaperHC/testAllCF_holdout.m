function [] = testAllCF_holdout (urm,percentageTest,profileLength)

%addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath(genpath('/home/turrin/matlab/Engineering'));

    onlineParamSvd.valueToAdd=2.5;
    onlineParamSvd.postProcessingFunction=@onlineRatingBias;

    [positiveTestsetReturn,negativeTestsetReturn]=extractTestSetsLongProfileUnpopular (urm,percentageTest,-1,0,profileLength,1,0);

    for i=1:length(positiveTestsetReturn.i)
        urmTrain=urm;
        urmTrain(positiveTestsetReturn.i(i),positiveTestsetReturn.j(i))=0;
    end
    
% input urm è normalizzata urm-3 => a realtime i valori non nulli vengono
% incrementati di 0.5 (in modo da avere dislike 2.5)
%
% il confronto va poi fatto aggiungendo a questi valori 2.5..
% (urmConfronto)

    urmConfronto=urm;
    nonzeri=find(urm);
    urm(nonzeri)=urm(nonzeri)+0.5;
    urmConfronto(nonzeri)=urm(nonzeri)+2.5;
    
%{
%%%%%%% SVD (sarwar)        

    lss=[150, 300];
    
    fileName = ['rmseSVD_holdout_',mat2str(profileLength),'.mat'];
    if fileExist(fileName) load(fileName); end      

for i=1:length(lss)
    tic
    model.ls = lss(i)
    [positiveTests,negativeTests]=holdOut('/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,urmTrain,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamSvd);
    eval([ '[rmseSVD',num2str(lss(i)),']=computeRMSE(positiveTests,urmConfronto)' ]);    
    save(fileName,'rmseSVD*');
    toc
end
    
%}
    

%%%%%%% COS

    knnn=[200];

    fileName = ['rmseCOS_',mat2str(profileLength),'.mat'];
    if fileExist(fileName) load(fileName); end
for i=1:length(knnn)
    tic
    model.knn=knnn(i)
    [positiveTests,negativeTests]=holdOut('/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn_test,urm,urmTrain,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamSvd);
    eval([ '[rmseCOS',num2str(knnn(i)),']=computeRMSE(positiveTests,urmConfronto)' ]);
    save(fileName,'rmseCOS*');    
    toc
end    
    

    
end