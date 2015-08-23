function [] = testCF_topK_koren (urm,urmProbe,sarwarVT)

%addpath('/home/turrin/matlab/coldstart/fw_urmTimestamp/matlabCode');
addpath(genpath('/home/turrin/matlab/Engineering'));

rand('state',3);


    [a,b]=find(urmProbe==5);
    testSet=sparse(a,b,1);
    
    display(['size testSet=',num2str(nnz(testSet))]);

    %[positiveTestsetReturn,negativeTestsetReturn]=extractTestSets (testSet,1.0,-1);
	[positiveTestsetReturn,negativeTestsetReturn]=extractTestSets (testSet,0.05,-1);

    urmModel=urm-urmProbe;


%%%%%% MOVIE AVERAGE (non-personalized)
disp(' started MovieAvg');

    fileNameRMSE = ['rmseMovieAVG_probe_','','.mat'];
    fileNameRANK = ['rankMovieAVG_probe_','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end      
    if fileExist(fileNameRANK) load(fileNameRANK); end 

%    model=[];
    onlineParamMovieAVG.postProcessingFunction=@keepXrandomItems;
    onlineParamMovieAVG.numberOfItems=100;
    onlineParamMovieAVG.filterViewedItems=true;
    tic
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/movieAvg', @createModel_movieAvg, @onLineRecom_movieAvg,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,1,onlineParamMovieAVG);
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
    onlineParamTopRated.postProcessingFunction=@keepXrandomItems;
    onlineParamTopRated.numberOfItems=100;
    onlineParamTopRated.filterViewedItems=true;
    tic
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/topRated', @createModel_toprated, @onLineRecom_toprated,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,1,onlineParamTopRated);
    eval([ '[rmseTopRated','',']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseTopRated*');
    eval([ '[rankTopRated','',']=computeRank(positiveTests)' ]); 
    save(fileNameRANK,'rankTopRated*');
    toc




    

    
%%%%%%% COS

    knnn=[200];

    %fileNameRMSE = ['rmseCOS_probe_','','.mat'];
    %fileNameRANK = ['rankCOS_probe_','','.mat'];
    fileNameRMSE = ['rmseCOS_probeOLD_','','.mat'];
    fileNameRANK = ['rankCOS_probeOLD_','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end      
    if fileExist(fileNameRANK) load(fileNameRANK); end 
    
    onlineParamCOS.postProcessingFunction=@keepXrandomItems;
    onlineParamCOS.numberOfItems=100;
    onlineParamCOS.filterViewedItems=true;
for i=1:length(knnn)
    tic
    model.knn=knnn(i)
    model.memoryProblem=true;
    %[positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn_test,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamCOS);
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/ItemItem_cosineKNN', @createModel_cosineIIknn, @onLineRecom_cosineIIknn,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamCOS);
    eval([ '[rmseCOS',num2str(knnn(i)),']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseCOS*');
    eval([ '[rankCOS',num2str(knnn(i)),']=computeRank(positiveTests)' ]); 
    save(fileNameRANK,'rankCOS*');     
    toc
end





%%%%%%  SVD (sarwar)        

    lss=[150, 50, 300];
    
    fileNameRMSE = ['rmseSVD_probe_','','.mat'];
    fileNameRANK = ['rankSVD_probe_','','.mat'];
    if fileExist(fileNameRMSE) load(fileNameRMSE); end      
    if fileExist(fileNameRANK) load(fileNameRANK); end 

    model.vt=sarwarVT;
    onlineParamSvd.postProcessingFunction=@keepXrandomItems;
    onlineParamSvd.numberOfItems=100;
    onlineParamSvd.filterViewedItems=true;
for i=1:length(lss)
    tic
    model.ls = lss(i)
    [positiveTests,negativeTests]=leaveOneOut('/home/turrin/matlab/Engineering/sarwar_withVT', @createModel_sarwarWithVT, @onLineRecom_sarwarWithVT,urm,urmModel,positiveTestsetReturn,negativeTestsetReturn,model,onlineParamSvd);
    eval([ '[rmseSVD',num2str(lss(i)),']=computeRMSE(positiveTests,urm)' ]);    
    save(fileNameRMSE,'rmseSVD*');
    eval([ '[rankSVD',num2str(lss(i)),']=computeRank(positiveTests)' ]); 
    save(fileNameRANK,'rankSVD*');
    toc
end





   
    
end