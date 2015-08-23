function [] = testCF_topK_korenUnpopoular (urm,urmProbe,unpopularThreshold,sarwarVT)
% function [] = testCF_topK_koren (urm, urmProbe, unpopularThreshold, [sarwarVT])

addpath(genpath('/home/turrin/matlab/Engineering'));

if (nargin<3)
    help testCF_topK_korenUnpopoular;
    return;
end

    urmModel=urm-urmProbe;

if (unpopularThreshold<1) 
    itemPivotPopular = findRatingPercentile(urmModel, unpopularThreshold);
else
    itemPivotPopular = unpopularThreshold;
end

display(['unpopular Threshold = ',num2str(itemPivotPopular )]);

    [a,b]=find(urmProbe==5);
    testSet=sparse(a,b,1);
    testSet(size(urmProbe,1),size(urmProbe,2))=0;
    
    display(['size testSet=',num2str(nnz(testSet))]);
    
    %percentageTest = 0.05;
    percentageTest = 1.0;
    [positiveTestsetReturn,negativeTestsetReturn]=extractTestSetsUnpopular(testSet ,percentageTest,-1,itemPivotPopular,1,urmModel);


%%%%%% MOVIE AVERAGE (non-personalized)
disp(' started MovieAvg');

    fileNameRMSE = ['rmseMovieAVG_probe_','','.mat'];
    fileNameRANK = ['rankMovieAVG_probe_','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end      
    if fileExist(fileNameRANK) load(fileNameRANK); end 

%    model=[];
    onlineParamMovieAVG.postProcessingFunction=@keep1000randomItems;
    onlineParamMovieAVG.filterViewedItems=true;
    tic
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/movieAvg', @createModel_movieAvg, @onLineRecom_movieAvg,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,1,onlineParamMovieAVG);
    eval([ '[rmseMovieAVG','',']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseMovieAVG*');
    eval([ '[rankMovieAVG','',']=computeRank(positiveTests);' ]); 
    save(fileNameRANK,'rankMovieAVG*');
    toc


%%%%%% TOP RATED
disp(' started TopRated');

    fileNameRMSE = ['rmseTopRated_probe_','','.mat'];
    fileNameRANK = ['rankTopRated_probe_','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end      
    if fileExist(fileNameRANK) load(fileNameRANK); end 

%    model=[];
    onlineParamTopRated.postProcessingFunction=@keep1000randomItems;
    onlineParamTopRated.filterViewedItems=true;
    tic
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,1,onlineParamTopRated);
    eval([ '[rmseTopRated','',']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseTopRated*');
    eval([ '[rankTopRated','',']=computeRank(positiveTests);' ]); 
    save(fileNameRANK,'rankTopRated*');
    toc




    

    
%%%%%%% COS
disp(' started COS');  

    knnn=[20 50 200];

    %fileNameRMSE = ['rmseCOS_probe_','','.mat'];
    %fileNameRANK = ['rankCOS_probe_','','.mat'];
    fileNameRMSE = ['rmseCOS_probeNoNormalized_','','.mat'];
    fileNameRANK = ['rankCOS_probeNoNormalized_','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end      
    if fileExist(fileNameRANK) load(fileNameRANK); end 
    
    onlineParamCOS.postProcessingFunction=@keep1000randomItems;
    onlineParamCOS.filterViewedItems=true;
for i=1:length(knnn)
    tic
    model.knn=knnn(i)
    model.memoryProblem=true;
    %[positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn_test,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamCOS);
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamCOS);
    eval([ '[rmseCOS',num2str(knnn(i)),']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseCOS*');
    eval([ '[rankCOS',num2str(knnn(i)),']=computeRank(positiveTests);' ]); 
    save(fileNameRANK,'rankCOS*');     
    toc
end





%%%%%%  SVD (sarwar)
disp(' started sarwar');    

    lss=[150, 50, 300];
    
    fileNameRMSE = ['rmseSVD_probe_','','.mat'];
    fileNameRANK = ['rankSVD_probe_','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end      
    if fileExist(fileNameRANK) load(fileNameRANK); end 

    onlineParamSvd.postProcessingFunction=@keep1000randomItems;
    onlineParamSvd.filterViewedItems=true;
for i=1:length(lss)
    tic
    model.ls = lss(i)
    if (exist('sarwarVT')==0)
        [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/sarwar', @createModel_sarwar, @onLineRecom_sarwar,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamSvd);
    else
        model.vt=sarwarVT;
        [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/sarwar_withVT', @createModel_sarwarWithVT, @onLineRecom_sarwarWithVT,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamSvd);
    end
    eval([ '[rmseSVD',num2str(lss(i)),']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseSVD*');
    eval([ '[rankSVD',num2str(lss(i)),']=computeRank(positiveTests);' ]); 
    save(fileNameRANK,'rankSVD*');
    toc
end





%%%%%%% ITEM-ITEM_pearsonKOREN on residuals
disp(' started ITEM-ITEM_pearsonKOREN on residuals');

    knnn=[20 200];
    clear modelParam;

    fileNameRMSE = ['rmseIIpearsonKoren_probeOnresiduals_','','.mat'];
    fileNameRANK = ['rankIIpearsonKoren_probeOnresiduals_','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end      
    if fileExist(fileNameRANK) load(fileNameRANK); end 
	
    fileNameIIpearsonKorenModel = '_model_IIpearsonKoren_onredisuals.mat';
    if fileExist(fileNameIIpearsonKorenModel) 
        load(fileNameIIpearsonKorenModel ); 
        modelParam.model = model;
    else
        modelParam.similarityOnResidual = true;
    end 
    
    onlineParamIIpearsonKoren.postProcessingFunction=@keep1000randomItems;
    onlineParamIIpearsonKoren.filterViewedItems=true;
    modelParam.memoryProblem=true;
for i=1:length(knnn)
    tic
    modelParam.knn=knnn(i);
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/ItemItem_pearsonKoren', @createModel_pearsonIIkoren, @onLineRecom_pearsonIIkoren,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,modelParam,onlineParamIIpearsonKoren);
    eval([ '[rmseIIpearsonKoren',num2str(knnn(i)),']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseIIpearsonKoren*');
    eval([ '[rankIIpearsonKoren',num2str(knnn(i)),']=computeRank(positiveTests);' ]); 
    save(fileNameRANK,'rankIIpearsonKoren*');     
    toc
end




%%%%%%% ITEM-ITEM_pearsonKOREN on originals
disp(' started ITEM-ITEM_pearsonKOREN on originals');

    knnn=[20 200];
    clear modelParam;

    fileNameRMSE = ['rmseIIpearsonKoren_probeOnoriginals_','','.mat'];
    fileNameRANK = ['rankIIpearsonKoren_probeOnoriginals_','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end      
    if fileExist(fileNameRANK) load(fileNameRANK); end 
	
    fileNameIIpearsonKorenModel = '_model_IIpearsonKoren_onoriginals.mat';
    if fileExist(fileNameIIpearsonKorenModel) 
        load(fileNameIIpearsonKorenModel ); 
        modelParam.model = model;
    else
        modelParam.similarityOnResidual = false;
    end 
    
    onlineParamIIpearsonKoren.postProcessingFunction=@keep1000randomItems;
    onlineParamIIpearsonKoren.filterViewedItems=true;
    modelParam.memoryProblem=true;
for i=1:length(knnn)
    tic
    modelParam.knn=knnn(i);
    onlineParamIIpearsonKoren.knn=knnn(i);
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/ItemItem_pearsonKoren', @createModel_pearsonIIkoren, @onLineRecom_pearsonIIkoren,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,modelParam,onlineParamIIpearsonKoren);
    eval([ '[rmseIIpearsonKoren',num2str(knnn(i)),']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseIIpearsonKoren*');
    eval([ '[rankIIpearsonKoren',num2str(knnn(i)),']=computeRank(positiveTests);' ]); 
    save(fileNameRANK,'rankIIpearsonKoren*');     
    toc
end


   
    
end