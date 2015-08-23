function [] = testLSA_holdout (urm,icmItemModel,percentageTest,profileLength)
% testLSA_holdout (urm,icmItemModel,percentageTest,profileLength)

%addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath(genpath('/home/turrin/matlab/Engineering'));

    fileNameLSA = ['rmseLSA_holdout_',mat2str(profileLength),'.mat'];
    if fileExist(fileNameLSA) load(fileNameLSA); end    

    tic

    onlineParamSvd.valueToPostMultiplyFor=5;
    onlineParamSvd.postProcessingFunction=@onlineRatingBias;

    [positiveTestsetReturn,negativeTestsetReturn]=extractTestSetsLongProfileUnpopular (urm,percentageTest,-1,0,profileLength,1,0);
    
    urmTrain=urm;
    for i=1:length(positiveTestsetReturn.i)
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
    
    
    model.itemModel = icmItemModel;
    
    tic
    
    
    ls =150
    model.ls = ls;
    [positiveTests,negativeTests]=holdOut('/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urm,urmTrain,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamSvd);    
    [rmseLSA150]=computeRMSE(positiveTests,urmConfronto);

    toc, tic

    save(fileNameLSA,'rmseLSA*');
    
    
    ls =300
    model.ls = ls;
    [positiveTests,negativeTests]=holdOut('/home/turrin/matlab/Engineering/lsaCosine', @createModel_lsaCosine, @onLineRecom_lsaCosine,urm,urmTrain,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamSvd);     
    [rmseLSA300]=computeRMSE(positiveTests,urmConfronto);

    toc

    save(fileNameLSA,'rmseLSA*');
    
end