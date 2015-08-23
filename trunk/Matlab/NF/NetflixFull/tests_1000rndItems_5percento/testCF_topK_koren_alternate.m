function [] = testCF_topK_koren (urm,urmProbe,sarwarVT)
% function [] = testCF_topK_koren (urm, urmProbe, [sarwarVT])

if (nargin<2)
    help testCF_topK_koren;
    return;
end

%addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath(genpath('~/matlab/Engineering'));
addpath(genpath('~/matlab/base'));


    [a,b]=find(urmProbe==5);
    testSet=sparse(a,b,1);
    
    display(['size testSet=',num2str(nnz(testSet))]);

    [positiveTestsetReturn,negativeTestsetReturn]=extractTestSets (testSet,0.01,-1);
    %[positiveTestsetReturn,negativeTestsetReturn]=extractTestSets (testSet,0.05,-1);

    urmModel=urm-urmProbe;

%{


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
    [positiveTests,negativeTests]=leaveOneOut('/home/roby/matlab/Engineering/movieAvg', @createModel_movieAvg, @onLineRecom_movieAvg,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,1,onlineParamMovieAVG);
    eval([ '[rmseMovieAVG','',']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseMovieAVG*');
    eval([ '[rankMovieAVG','',']=computeRank(positiveTests)' ]); 
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
    [positiveTests,negativeTests]=leaveOneOut('/home/roby/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,1,onlineParamTopRated);
    eval([ '[rmseTopRated','',']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseTopRated*');
    eval([ '[rankTopRated','',']=computeRank(positiveTests)' ]); 
    save(fileNameRANK,'rankTopRated*');
    toc




    

    
%%%%%%% COS
disp(' started COS');  

    knnn=[200];

    %fileNameRMSE = ['rmseCOS_probe_','','.mat'];
    %fileNameRANK = ['rankCOS_probe_','','.mat'];
    fileNameRMSE = ['rmseCOS_probeOLD_','','.mat'];
    fileNameRANK = ['rankCOS_probeOLD_','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end      
    if fileExist(fileNameRANK) load(fileNameRANK); end 
    
    onlineParamCOS.postProcessingFunction=@keep1000randomItems;
    onlineParamCOS.filterViewedItems=true;
for i=1:length(knnn)
    tic
    model.knn=knnn(i)
    model.memoryProblem=true;
    %[positiveTests,negativeTests]=leaveOneOut('/home/roby/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn_test,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamCOS);
    [positiveTests,negativeTests]=leaveOneOut('/home/roby/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamCOS);
    eval([ '[rmseCOS',num2str(knnn(i)),']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseCOS*');
    eval([ '[rankCOS',num2str(knnn(i)),']=computeRank(positiveTests)' ]); 
    save(fileNameRANK,'rankCOS*');     
    toc
end


%%%%%%% COS UNBIASED
disp(' started COS UNBIASED');  

    knnn=[200];

    fileNameRMSE = ['rmseCOSunbiased_probe_onoriginals','','.mat'];
    fileNameRANK = ['rankCOSunbiased_probe_onoriginals','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end      
    if fileExist(fileNameRANK) load(fileNameRANK); end 
    
    onlineParamCOS.postProcessingFunction=@keep1000randomItems;
    onlineParamCOS.filterViewedItems=true;
for i=1:length(knnn)
    tic
    model.knn=knnn(i)
    model.memoryProblem=true;
    model.computeBaseline=true;
    [positiveTests,negativeTests]=leaveOneOut('/home/roby/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn_unbiased,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamCOS);
    eval([ '[rmseCOSunbiased',num2str(knnn(i)),']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseCOSunbiased*');
    eval([ '[rankCOSunbiased',num2str(knnn(i)),']=computeRank(positiveTests);' ]); 
    save(fileNameRANK,'rankCOSunbiased*');     
    toc
end

%}

%%%%%%% Non normalized COS UNBIASED SHRANK
disp(' started COS Non normalized UNBIASED SHRANK');

    knnn=[200];

    fileNameRMSE = ['rmseNNCOS_unbiased_shrank100_onoriginals','','.mat'];
    fileNameRANK = ['rankNNCOS_unbiased_shrank100_onoriginals','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end
    if fileExist(fileNameRANK) load(fileNameRANK); end

    fileNameCOSunbiasedshrank = '_model_COSunbiasedshrank100.mat';

    if fileExist(fileNameCOSunbiasedshrank ) 
        load(fileNameCOSunbiasedshrank ); 
        modelParam.model = model;
    else
	 modelParam.memoryProblem=true;
        modelParam.computeBaseline=true;
        modelParam.lambdaS=100;
	 modelParam.SimilarityShrinkage=true;
    end  

    onlineParamCOS.postProcessingFunction=@keep1000randomItems;
    onlineParamCOS.filterViewedItems=true;
for i=1:length(knnn)
    tic
    modelParam.knn=knnn(i)
    [positiveTests,negativeTests]=leaveOneOut('/home/roby/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn_unbiased,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,modelParam,onlineParamCOS);    
    eval([ '[rmseCOSunbiasedshrank',num2str(knnn(i)),']=computeRMSE(positiveTests,urm)' ]);
    save(fileNameRMSE,'rmseCOSunbiasedshrank*');
    eval([ '[rankCOSunbiasedshrank',num2str(knnn(i)),']=computeRank(positiveTests);' ]);
    save(fileNameRANK,'rankCOSunbiasedshrank*');
    toc
end



%{



%%%%%%  SVD (sarwar)
disp(' started sarwar');    

    lss=[150, 50, 300];
    
    fileNameRMSE = ['rmseSVD_probe_','','.mat'];
    fileNameRANK = ['rankSVD_probe_','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end      
    if fileExist(fileNameRANK) load(fileNameRANK); end 

    model.vt=sarwarVT;
    onlineParamSvd.postProcessingFunction=@keep1000randomItems;
    onlineParamSvd.filterViewedItems=true;
for i=1:length(lss)
    tic
    model.ls = lss(i)
    [positiveTests,negativeTests]=leaveOneOut('/home/roby/matlab/Engineering/sarwar_withVT', @createModel_sarwarWithVT, @onLineRecom_sarwarWithVT,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamSvd);
    eval([ '[rmseSVD',num2str(lss(i)),']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseSVD*');
    eval([ '[rankSVD',num2str(lss(i)),']=computeRank(positiveTests)' ]); 
    save(fileNameRANK,'rankSVD*');
    toc
end




%%%%%%  SVD (sarwarubiased)
disp(' started sarwar unbiases');    

    lss=[150, 50, 300];
    
    fileNameRMSE = ['rmseSVDunbias3_probe_','','.mat'];
    fileNameRANK = ['rankSVDunbias3_probe_','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end      
    if fileExist(fileNameRANK) load(fileNameRANK); end 

    model.vt=sarwarVT;
    onlineParamSvd.postProcessingFunction=@keep1000randomItems;
    onlineParamSvd.filterViewedItems=true;
    onlineParamSvd.bias = 3;
for i=1:length(lss)
    tic
    model.ls = lss(i)
    [positiveTests,negativeTests]=leaveOneOut('/home/roby/matlab/Engineering/sarwar_withVT', @createModel_sarwarWithVT, @onLineRecom_sarwarWithVT,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamSvd);
    eval([ '[rmseSVDunbias3',num2str(lss(i)),']=computeRMSE(positiveTests,urm);' ]);    
    save(fileNameRMSE,'rmseSVDunbias3*');
    eval([ '[rankSVDunbias3',num2str(lss(i)),']=computeRank(positiveTests);' ]); 
    save(fileNameRANK,'rankSVDunbias3*');
    toc
end





%%%%%%% ITEM-ITEM_pearsonKOREN on residuals
disp(' started ITEM-ITEM_pearsonKOREN on residuals');

    knnn=[20];
    clear modelParam;

    fileNameRMSE = ['rmseIIpearsonKoren_probeOnresiduals_','','.mat'];
    fileNameRANK = ['rankIIpearsonKoren_probeOnresiduals_','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end      
    if fileExist(fileNameRANK) load(fileNameRANK); end 
	
    fileNameIIpearsonKorenModel = '_model_IIpearsonKoren_onredisuals.mat';
    if fileExist(fileNameIIpearsonKorenModel) 
        load(fileNameIIpearsonKorenModel ); 
        modelParam.model = model;
    end 
    
    onlineParamIIpearsonKoren.postProcessingFunction=@keep1000randomItems;
    onlineParamIIpearsonKoren.filterViewedItems=true;
    modelParam.memoryProblem=true;
for i=1:length(knnn)
    tic
    modelParam.knn=knnn(i);
    [positiveTests,negativeTests]=leaveOneOut('/home/roby/matlab/Engineering/ItemItem_pearsonKoren', @createModel_pearsonIIkoren, @onLineRecom_pearsonIIkoren,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,modelParam,onlineParamIIpearsonKoren);
    eval([ '[rmseIIpearsonKoren',num2str(knnn(i)),']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseIIpearsonKoren*');
    eval([ '[rankIIpearsonKoren',num2str(knnn(i)),']=computeRank(positiveTests);' ]); 
    save(fileNameRANK,'rankIIpearsonKoren*');     
    toc
end


%%%%%%% ITEM-ITEM_pearsonKOREN on originals
disp(' started ITEM-ITEM_pearsonKOREN on originals');

    knnn=[20];
    clear modelParam;

    fileNameRMSE = ['rmseIIpearsonKoren_probeOnoriginals_','','.mat'];
    fileNameRANK = ['rankIIpearsonKoren_probeOnoriginals_','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end      
    if fileExist(fileNameRANK) load(fileNameRANK); end 
	
    fileNameIIpearsonKorenModel = '_model_IIpearsonKoren_onoriginals.mat';
    if fileExist(fileNameIIpearsonKorenModel) 
        load(fileNameIIpearsonKorenModel ); 
        modelParam.model = model;
    end 
    
    onlineParamIIpearsonKoren.postProcessingFunction=@keep1000randomItems;
    onlineParamIIpearsonKoren.filterViewedItems=true;
    modelParam.memoryProblem=true;
for i=1:length(knnn)
    tic
    modelParam.knn=knnn(i);
    [positiveTests,negativeTests]=leaveOneOut('/home/roby/matlab/Engineering/ItemItem_pearsonKoren', @createModel_pearsonIIkoren, @onLineRecom_pearsonIIkoren,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,modelParam,onlineParamIIpearsonKoren);
    eval([ '[rmseIIpearsonKoren',num2str(knnn(i)),']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseIIpearsonKoren*');
    eval([ '[rankIIpearsonKoren',num2str(knnn(i)),']=computeRank(positiveTests);' ]); 
    save(fileNameRANK,'rankIIpearsonKoren*');     
    toc
end


   

%%%%%%% Koren NewNgbr %%%%%%%%%%
disp(' started Koren NewNgbr');
    clear modelParam;

    fileNameRMSE = ['rmseKorenNewNbgr_probe','','.mat'];
    fileNameRANK = ['rankKorenNewNbgr_probe','','.mat'];

    onlineParamIIpearsonKoren.postProcessingFunction=@keep1000randomItems;
    onlineParamIIpearsonKoren.filterViewedItems=true;   
    
    fileNameNewNgbrModel = '_model_NewNgbrModel.mat';
    if fileExist(fileNameNewNgbrModel) 
        load(fileNameNewNgbrModel); 
        modelParam.model = model;
        ls = model.ls;
    else
        modelParam.ls=50;
        ls=50;
    end     
    tic
    [positiveTests,negativeTests]=leaveOneOut('~/matlab/Engineering/NewNgbr_Koren', @createModel_NewNgbr_Koren, @onLineRecom_NewNgbr_Koren,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,modelParam,onlineParamIIpearsonKoren);
    eval([ '[rmseNewNgbr',num2str(ls),']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseNewNgbr*');
    eval([ '[rankNewNgbr',num2str(ls),']=computeRank(positiveTests);' ]); 
    save(fileNameRANK,'rankNewNgbr*');     
    toc  



    %%%%%%% Koren Integrated %%%%%%%%%%
    disp(' started Koren Integrated SVD');
    clear modelParam;

    fileNameRMSE = ['rmseKorenIntegratedSvd_probe','','.mat'];
    fileNameRANK = ['rankKorenIntegratedSvd_probe','','.mat'];

    onlineParamIntegratedSvd.postProcessingFunction=@keep1000randomItems;
    onlineParamIntegratedSvd.filterViewedItems=true;   
    
    fileNameIntegratedSvd = '_model_IntegratedSvd.mat';
    if fileExist(fileNameIntegratedSvd) 
        load(fileNameIntegratedSvd); 
        modelParam.model = model;
        ls = model.ls;
    else
        error ('missing model');
    end     
    tic
    [positiveTests,negativeTests]=leaveOneOut('~/matlab/Engineering/KorenIntegratedSvd', @createModel_KorenIntegratedSvd, @onLineRecom_KorenIntegratedSvd,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,modelParam,onlineParamIntegratedSvd);
    eval([ '[rmseIntegratedSvd',num2str(ls),']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseIntegratedSvd*');
    eval([ '[rankIntegratedSvd',num2str(ls),']=computeRank(positiveTests);' ]); 
    save(fileNameRANK,'rankIntegratedSvd*');     
    toc      
   


%%%%%%% Koren NewNgbr TOPK %%%%%%%%%%
disp(' started Koren NewNgbr TOPK');
    clear modelParam;

    fileNameRMSE = ['rmseKorenNewNbgrTopK_probe','','.mat'];
    fileNameRANK = ['rankKorenNewNbgrTopK_probe','','.mat'];

    onlineParamIIpearsonKorenTopK.postProcessingFunction=@keep1000randomItems;
    onlineParamIIpearsonKorenTopK.filterViewedItems=true;   
    
    fileNameNewNgbrModel = '_provaModelTopK_ML.mat';
    if fileExist(fileNameNewNgbrModel) 
        load(fileNameNewNgbrModel); 
        modelParam.model = model;
        ls = model.ls;
    else
        modelParam.ls=50;
        ls=50;
    end     
    tic
    [positiveTests,negativeTests]=leaveOneOut('~/matlab/Engineering/TOPK-NewNgbr_Koren', @createModel_TopK_NewNgbrKoren, @onLineRecom_TopK_NewNgbrKoren,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,modelParam,onlineParamIIpearsonKorenTopK);
    eval([ '[rmseNewNgbrTopK',num2str(ls),']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseNewNgbrTopK*');
    eval([ '[rankNewNgbrTopK',num2str(ls),']=computeRank(positiveTests);' ]); 
    save(fileNameRANK,'rankNewNgbrTopK*');     
    toc    

%}
 
end
