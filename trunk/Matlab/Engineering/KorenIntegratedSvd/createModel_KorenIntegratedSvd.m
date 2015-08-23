function [model] = createModel_KorenIntegratedSvd (URM,param)
% URM = matrix with user-ratings
% param: 	[param.model] --> opzionale, contiene già modello utenti e item 
%                               e i bias (global effects)
%           [param.modelSimilarity] --> opzionale, contiene già il modello pearson item-item
%           [param.continueIterate] --> together with param.model, if TRUE
%               continue to iterate starting from the passed model. Default
%               value is FALSE
%           [param.iterations] --> number of iterations
%           [param.lambdaS] -->  shrinking factor per s_{ij}
%           [param.lambdaI] -->  shrinking factor per media item b_{i}
%           [param.lambdaU] -->  shrinking factor per media user b_{u}
%           [param.lambda6] --> regularization factor
%           [param.lambda7] --> regularization factor
%           [param.lambda8] --> regularization factor
%           [param.lrate1] --> learning rate
%           [param.lrate2] --> learning rate
%           [param.lrate3] --> learning rate
%           [param.scalingFactor_lrate] --> after each iteration, it scales
%                                           all the lrates by this factor
%           [param.ls] --> latent size (number of factors)
%           [param.knn] --> neighborhood size
%           [param.initialize] --> uniform interval for initializing
%                               matrices. Default value is [-0.001, +0.001]
%           [param.fastBiasInit] --> perform a fast initialization of
%                                    biases (random). Default value is
%                                    FALSE
%
%
% model:    model.mu --> average rating
%           model.bu --> vector of the average rating for each user
%           model.bi --> vector of the average rating for each item
%           model.q 
%           model.p
%           model.y
%           model.w
%           model.c
%           model.lambdaS -->  shrinking factor USED per s_{ij}
%           model.lambdaI -->  shrinking factor USED per media item b_{i}
%           model.lambdaU -->  shrinking factor USED per media user b_{u}
%           model.S --> item-item similarity
%			model.ls --> latent size USED
%			model.knn --> neighborhood size USED
%           model.lrate1..3 --> learning rate USED
%           model.scalingFactor_lrate --> scalingFactor_lrate USED
%           model.lambda6..8 --> regularization factor USED
%           model.iterations --> iterations USED
%           model.useruser --> useruser mode USED
%           model.initialize --> initialization USED
%           model.fastBiasInit --> fastBiasInit USED
%
% reference paper: 
%      "Factorization Meets the Neighborhood: a Multifaceted Collaborative Filtering Model"
%      Yehuda Koren, AT&T Labs - Research
%      KDD 2008, Las Vegas, Nevada, USA

rand('state',37);

    if (~exist('param')) 
        param=struct();
    end

    continueIterate = false;
    if (isfield(param,'model'))
        model=param.model;
        if (isfield(param,'continueIterate'))
            if (islogical(param.continueIterate))
                continueIterate = param.continueIterate;
            end
        end
        if (~continueIterate)
            return;
        else
            display('..IntegratedSVD: continuing iteration starting from previous model');
        end
    end
    
    if (isfield(param,'iterations'))
        iterations = param.iterations;
    else 
        iterations=10;
    end     
    totiterations = iterations;
    display(['..IntegratedSVD: iterations=',num2str(iterations)]);
    
if (~continueIterate)
    if (isfield(param,'ls'))
        ls = param.ls;
    else 
        ls= 200;
    end    
    if (isfield(param,'lambdaS'))
        lambdaS = param.lambdaS;
    else 
        lambdaS=100;
    end    
    if (isfield(param,'lambdaI'))
        lambdaI = param.lambdaI;
    else 
        lambdaI=25;
    end
    if (isfield(param,'lambdaU'))
        lambdaU = param.lambdaU;
    else 
        lambdaU=10;
    end    
    if (isfield(param,'lambda6'))
        lambda6 = param.lambda6;
    else 
        lambda6=0.005;
    end       
    if (isfield(param,'lambda7'))
        lambda7 = param.lambda7;
    else 
        lambda7=0.015;
    end       
    if (isfield(param,'lambda8'))
        lambda8 = param.lambda8;
    else 
        lambda8=0.015;
    end           
    if (isfield(param,'lrate1'))
        lrate1 = param.lrate1;
    else 
        lrate1=0.007;
    end   
    if (isfield(param,'lrate2'))
        lrate2 = param.lrate2;
    else 
        lrate2=0.007;
    end   
    if (isfield(param,'lrate3'))
        lrate3 = param.lrate3;
    else 
        lrate3=0.001;
    end       
    if (isfield(param,'knn'))
        knn = param.knn;
    else 
        knn=300;
    end    
    if (isfield(param,'scalingFactor_lrate'))
        scalingFactor_lrate = param.scalingFactor_lrate;
    else 
        scalingFactor_lrate=0.9;
    end        
    initialize=[-0.001 0.001];
    if (isfield(param,'initialize'))
        if (length(param.initialize)==2)
            initialize = param.initialize;
        else
            warning('param.initialize has wrong format.. default value will be used instead');            
        end
    end 
    fastBiasInit = false;
    if (isfield(param,'fastBiasInit'))
        if (islogical(param.fastBiasInit))
            fastBiasInit = param.fastBiasInit;
        else
            warning('param.fastBiasInit has wrong format.. default value will be used instead');
        end
    end    
    
    minvalue = initialize(1);
    rangevalue = initialize(2)-initialize(1);
    
    
    %%% COMPUTE ITEM-ITEM SIMILARITY MATRIX and biases my using 
    %%% "pearson item-item Koren"
    paramSimilarity.knn = knn;
    paramSimilarity.lambdaS = lambdaS;
    paramSimilarity.lambdaI = lambdaI;
    paramSimilarity.lambdaU = lambdaU;
    if (isfield(param,'modelSimilarity'))
        modelSimilarity = param.modelSimilarity;
    else
        modelSimilarity = createModel_pearsonIIkoren (URM,paramSimilarity);
    end
    
    if (fastBiasInit)
        display('Fast bias initialization');
        bu = minvalue+rangevalue*rand(size(URM,1),1);
        bi = minvalue+rangevalue*rand(size(URM,2),1);
    else    
        bu = modelSimilarity.bu;
        bi = modelSimilarity.bi;
    end
    mu = modelSimilarity.mu;
    S = modelSimilarity.dr;
    

    %%% INITIALIZE MODELS    
    display([' - IntegratedSVD: Koren - initialization: ',num2str(minvalue),'+',num2str(rangevalue),'*random']);
    q = minvalue+rangevalue*rand(ls,size(URM,2));
    p = minvalue+rangevalue*rand(ls,size(URM,1));
    y = minvalue+rangevalue*rand(ls,size(URM,2));

    %%% w & c are sparse, only on knn values...
    [nnzI,nnzJ]=find(S);
    w = sparse(nnzI,nnzJ,minvalue+rangevalue*rand(length(nnzI),1));
    w(size(URM,2),size(URM,2))=0; %force size
    c = sparse(nnzI,nnzJ,minvalue+rangevalue*rand(length(nnzI),1));
    c(size(URM,2),size(URM,2))=0; %force size
    %%% 
else
    mu = model.mu;
    bu = model.bu;
    bi = model.bi;
    lrate1=model.lrate1;
    lrate2=model.lrate2;
    lrate3=model.lrate3;
    scalingFactor_lrate = model.scalingFactor_lrate;
    lambda6=model.lambda6;
    lambda7=model.lambda7;
    lambda8=model.lambda8;
    q=model.q;
    p=model.p;
    y=model.y;
    w=model.w;
    c=model.c;
    S=model.S;
    totiterations = model.iterations + iterations;
    lambdaS = model.lambdaS;
	lambdaI = model.lambdaI;
    lambdaU = model.lambdaU;
    ls = model.ls;    
    knn = model.knn;    
    fastBiasInit = model.fastBiasInit;
    initialize = model.initialize;
end
    
    timeHandle = tic;
    display([' - IntegratedSVD: Koren - started gradient descent']);
    [buout,biout,qout,pout,yout,wout,cout]=learnIntegratedModel(URM,mu,bu,bi,iterations,knn,lrate1,lrate2,lrate3,scalingFactor_lrate,lambda6,lambda7,lambda8,q,p,y,w,c,S);
    display([' - IntegratedSVD: Koren - Gradient descent completed in ',num2str(toc(timeHandle)),' sec - ']);
    
    
    model.mu = mu;
    model.bu = buout;
    model.bi = biout;
    model.q = qout;
    model.p = pout;
    model.y = yout;
    model.w = wout;
    model.c = cout;
    
    model.lambdaS = lambdaS;
	model.lambdaI = lambdaI;
    model.lambdaU = lambdaU;
    model.lambda6 = lambda6;
    model.lambda7 = lambda7;
    model.lambda8 = lambda8;
    model.ls = ls;    
    model.knn = knn;
    model.S = S;
    model.iterations = totiterations;
    model.lrate1 = lrate1;
    model.lrate2 = lrate2;
    model.lrate3 = lrate3;
    model.scalingFactor_lrate = scalingFactor_lrate;
    model.fastBiasInit = fastBiasInit;
    model.initialize = initialize;
end