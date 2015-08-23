function [model] = createModel_NewNgbr_Koren (URM,param)
% URM = matrix with user-ratings
% param: 	[param.model] --> opzionale, contiene già modello utenti e item 
%                               e i bias (global effects)
%           [param.continueIterate] --> together with param.model, if TRUE
%               continue to iterate starting from the passed model. Default
%               value is FALSE
%           [param.iterations] --> number of iterations
%           [param.lambdaS] -->  shrinking factor per s_{ij}
%           [param.lambdaI] -->  shrinking factor per media item b_{i}
%           [param.lambdaU] -->  shrinking factor per media user b_{u}
%           [param.lambda] --> regularization factor
%           [param.lrate] --> learning rate
%           [param.ls] --> latent size (number of factors)
%           [param.useruser] --> set if also user-user model has to be
%                                integrated. Default value is TRUE
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
%           model.x
%           model.y
%           model.p
%           model.z
%           model.lambdaS -->  shrinking factor USED per s_{ij}
%           model.lambdaI -->  shrinking factor USED per media item b_{i}
%           model.lambdaU -->  shrinking factor USED per media user b_{u}
%			model.ls --> latent size USED
%           model.lrate --> learning rate USED
%           model.iterations --> iterations USED
%           model.useruser --> useruser mode USED
%           model.initialize --> initialization USED
%           model.fastBiasInit --> fastBiasInit USED
%
% reference paper: 
% "Factor in the Neighbors: Scalable and Accurate Collaborative Filtering"
% Yehuda Koren, AT&T Labs - Research

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
            display('..NewNbgr: continuing iteration starting from previous model');
        end
    end
    
    if (isfield(param,'iterations'))
        iterations = param.iterations;
    else 
        iterations=10;
    end     
    totiterations = iterations;
    display(['..NewNbgr: iterations=',num2str(iterations)]);
    
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
    if (isfield(param,'lambda'))
        lambda = param.lambda;
    else 
        lambda=0.04;
    end       
    if (isfield(param,'lrate'))
        lrate = param.lrate;
    else 
        lrate=0.002;
    end   
    useruser = true;
    if (isfield(param,'useruser'))
        if (islogical(param.useruser))
            useruser = param.useruser;
        else
            warning('param.useruser has wrong format.. default value will be used instead');
        end
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
    
    mu = full(sum(sum(URM,1),2));
    mu = mu/nnz(URM);

    if (fastBiasInit)
        display('Pearson IIKoren: fast bias initialization');
        bu = minvalue+rangevalue*rand(size(URM,1),1);
        bi = minvalue+rangevalue*rand(size(URM,2),1);
    else
    %display('Pearson IIkoren: computing URM transpose');
        tic
        URMt=URM';
        display(['Pearson IIkoren: transpose computed in ',num2str(toc),' sec']);    

        display(' - Pearson IIkoren: computing biases - ');
        nnzI=zeros(1,size(URM,2));
        nnzU=zeros(1,size(URM,1));

        timeHandleBiases=tic;
        for i=1:length(nnzI)
            nnzI(i)=nnz(URM(:,i)); 
            if (mod(i,5000)==0),
                displayRemainingTime(i, length(nnzI),timeHandleBiases);           
            end       
        end
        bi = (sum(URM,1) - mu*(nnzI)) ./ (lambdaI + nnzI);

        for i=1:length(nnzU)
            nnzU(i)=nnz(URMt(:,i)); 
            if (mod(i,50000)==0),
                displayRemainingTime(i, length(nnzU),timeHandleBiases);           
            end       
        end   

        timeHandleBiases=tic;
        splitSize=100;
        splitNum=ceil(size(URM,1)/splitSize);
        tosub=zeros(1,size(URM,1));
        for i=1:splitNum
            maxRowNum=min([i*splitSize,size(URM,1)]);
            rowIndexes=splitSize*(i-1)+1:maxRowNum;

            tosub(rowIndexes)=sum(spones(URMt(:,rowIndexes)'.*(ones(length(rowIndexes),1)*bi)),2);

            if (mod(i,50000)==0),
                displayRemainingTime(i, splitNum,timeHandleBiases);           
            end          
        end
        bu = (sum(URM,2)' - mu*nnzU - tosub) ./ (lambdaU + nnzU);    
        clear URMt;  

    end
        %%% INITIALIZE MODELS    
        display([' - NewNbgr: Koren - initialization: ',num2str(minvalue),'+',num2str(rangevalue),'*random']);
        q = minvalue+rangevalue*rand(ls,size(URM,2));
        x = minvalue+rangevalue*rand(ls,size(URM,2));
        y = minvalue+rangevalue*rand(ls,size(URM,2));
        if (useruser)
            p = minvalue+rangevalue*rand(ls,size(URM,1));
            z = minvalue+rangevalue*rand(ls,size(URM,1));
        end
        %%% 
else
    mu = model.mu;
    bu = model.bu;
    bi = model.bi;
    lrate=model.lrate;
    lambda=model.lambda;
    useruser=model.useruser;
    q=model.q;
    x=model.x;
    y=model.y;
    if (model.useruser)
        p=model.p;
        z=model.z;
    end
    totiterations = model.iterations + iterations;
    lambdaS = model.lambdaS;
	lambdaI = model.lambdaI;
    lambdaU = model.lambdaU;
    ls = model.ls;    
    fastBiasInit = model.fastBiasInit;
    initialize = model.initialize;
end
    
    timeHandle = tic;
    display([' - NewNbgr: Koren - started gradient descent']);
    if (useruser)
        [buout,biout,qout,xout,yout,pout,zout]=learnFactorModel(URM,mu,bu,bi,iterations,lrate,lambda,q,x,y,p,z);
    else
        [buout,biout,qout,xout,yout]=learnFactorModel(URM,mu,bu,bi,iterations,lrate,lambda,q,x,y);
    end
    display([' - NewNbgr: Koren - Gradient descent completed in ',num2str(toc(timeHandle)),' sec - ']);
    
    model.mu = mu;
    model.bu = buout;
    model.bi = biout;
    model.q = qout;
    model.x = xout;
    model.y = yout;
    if (useruser)
        model.p = pout;
        model.z = zout;
    end
    
    model.lambdaS = lambdaS;
	model.lambdaI = lambdaI;
    model.lambdaU = lambdaU;
    model.lambda = lambda;
    model.ls = ls;    
    model.iterations = totiterations;
    model.lrate = lrate;
    model.useruser = useruser;
    model.fastBiasInit = fastBiasInit;
    model.initialize = initialize;
end