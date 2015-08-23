function Model = createModel(URM, Param)
%CREATEMODEL creates the model of the given user-ratings matrix using the
%NewNgbr_Koren Algorithm.
%   MODEL = CREATEMODEL(URM, PARAM)
%   has no optional parameter.
%   PARAM.Path must be set to include the utility directory.
%   PARAM.Model already contains the user and item models, and the bias.
%   PARAM.continueIterate (together with PARAM.Model) (default false)
%   whether to continue the iteration, starting from the passed model.
%   PARAM.iterations (default 10) is the number of iterations.
%   PARAM.lambdaS (default 100) is the shrinking factor of s_{ij}
%   PARAM.lambdaI (default 25) is the shrinking factor of mean item b_{i}
%   PARAM.lambdaU (default 10) is the shrinking factor of mean user b_{u}
%   PARAM.lambda (default 0.04) is the regularization factor
%   PARAM.lrate (default 0.002) is the learning rate
%   PARAM.ls (default 200) is the latent size (number of factors)
%   PARAM.useruser (default true) whether also the user-user model has to
%   be integrated.
%   PARAM.initialize (default [-0.001 +0.001]) is the uniform interval for
%   initializing matrices.
%   PARAM.fastBiasInit (default false) whether to perform a fast
%   initialization of biases (random).
%   
%   It returns a MODEL:
%   MODEL.mu is the average rating.
%   MODEL.bu is the vector of the average rating for each user.
%   MODEL.bi is the vector of the average rating for each item.
%   MODEL.q
%   MODEL.x
%   MODEL.y
%   MODEL.p
%   MODEL.z
%   MODEL.lambdaS is the shrinking factor used for s_{ij}
%   MODEL.lambdaI is the shrinking factor used for mean item b_{i}
%   MODEL.lambdaU is the shrinking factor used for mean user b_{u}
%   MODEL.ls is the latent size used
%   MODEL.lrate is the learning rate used
%   MODEL.iterations is the number of iterations used
%   MODEL.useruser is the useruser mode used
%   MODEL.initialize is the initialization used
%   MODEL.fastBiasInit is the fastBiasInit used
%   
%Reference paper: 
%"Factor in the Neighbors: Scalable and Accurate Collaborative Filtering"
%Yehuda Koren, AT&T Labs - Research
    
    if(nargin < 2)
        help createModel;
        return;
    end
    
    if(~isfield(Param, 'Path'))
        help createModel;
        return;
    end
    
    Path = [Param.Path filesep 'Utility'];
    addpath(Path);
    
	RandStream.setDefaultStream(RandStream('mt19937ar', 'seed', sum(1e5 * clock)));
    
    continueIterate = false;
    if(isfield(Param, 'Model'))
        Model = Param.Model;
        if(isfield(Param, 'continueIterate'))
            if(islogical(Param.continueIterate))
                continueIterate = Param.continueIterate;
            end
        end
        if(~continueIterate)
            return;
        else
            display('..NewNbgr: continuing iteration starting from previous model');
        end
    end
    
    if(isfield(Param, 'iterations'))
        iterations = Param.iterations;
    else 
        iterations = 10;
    end     
    totiterations = iterations;
    
    if(~continueIterate)
        if(isfield(Param, 'ls'))
            ls = Param.ls;
        else 
            ls = 200;
        end
        
        if(isfield(Param, 'lambdaS'))
            lambdaS = Param.lambdaS;
        else 
            lambdaS = 100;
        end
        
        if(isfield(Param, 'lambdaI'))
            lambdaI = Param.lambdaI;
        else 
            lambdaI = 25;
        end
        
        if(isfield(Param, 'lambdaU'))
            lambdaU = Param.lambdaU;
        else 
            lambdaU = 10;
        end
        
        if(isfield(Param, 'lambda'))
            lambda = Param.lambda;
        else 
            lambda = 0.04;
        end
        
        if(isfield(Param, 'lrate'))
            lrate = Param.lrate;
        else 
            lrate = 0.002;
        end
        
        useruser = true;
        if(isfield(Param, 'useruser'))
            if(islogical(Param.useruser))
                useruser = Param.useruser;
            end
        end
        
        initialize = [-0.001 0.001];
        if(isfield(Param, 'initialize'))
            if(length(Param.initialize) == 2)
                initialize = Param.initialize;         
            end
        end
        
        fastBiasInit = false;
        if(isfield(Param, 'fastBiasInit'))
            if(islogical(Param.fastBiasInit))
                fastBiasInit = Param.fastBiasInit;
            end
        end    

        minvalue = initialize(1);
        rangevalue = initialize(2) - initialize(1);

        mu = full(sum(sum(URM, 1), 2));
        mu = mu / nnz(URM);

        if(fastBiasInit)
            %display('Pearson IIKoren: fast bias initialization');
            bu = minvalue + rangevalue * rand(size(URM, 1), 1);
            bi = minvalue + rangevalue * rand(size(URM, 2), 1);
        else
            %display('Pearson IIkoren: computing URM transpose');
            tic;
            URMt = URM';
            display(['Pearson IIkoren: transpose computed in ' num2str(toc) ' seconds']);    

            display(' - Pearson IIkoren: computing biases - ');
            nnzI = zeros(1, size(URM, 2));
            nnzU = zeros(1, size(URM, 1));

            timeHandleBiases = tic;
            for i = 1:length(nnzI)
                nnzI(i) = nnz(URM(:, i)); 
                if(mod(i, 5000) == 0)
                    displayRemainingTime(i, length(nnzI), timeHandleBiases);           
                end       
            end
            
            bi = (sum(URM, 1) - mu * (nnzI)) ./ (lambdaI + nnzI);

            for i = 1:length(nnzU)
                nnzU(i) = nnz(URMt(:, i)); 
                if(mod(i, 50000) == 0)
                    displayRemainingTime(i, length(nnzU), timeHandleBiases);           
                end       
            end   

            timeHandleBiases = tic;
            splitSize = 100;
            splitNum = ceil(size(URM, 1) / splitSize);
            tosub = zeros(1, size(URM, 1));
            
            for i = 1:splitNum
                maxRowNum = min([i * splitSize, size(URM, 1)]);
                rowIndexes = splitSize * (i - 1) + 1:maxRowNum;

                tosub(rowIndexes) = sum(spones(URMt(:, rowIndexes)' .* (ones(length(rowIndexes), 1) * bi)), 2);

                if(mod(i, 50000) == 0)
                    displayRemainingTime(i, splitNum, timeHandleBiases);           
                end
            end
            
            bu = (sum(URM, 2)' - mu * nnzU - tosub) ./ (lambdaU + nnzU);    
            clear URMt;
        end
        
        display([' - NewNbgr: Koren - initialization: ' num2str(minvalue) ' + ' num2str(rangevalue) ' * random']);
        q = minvalue + rangevalue * rand(ls, size(URM, 2));
        x = minvalue + rangevalue * rand(ls, size(URM, 2));
        y = minvalue + rangevalue * rand(ls, size(URM, 2));
        
        if(useruser)
            p = minvalue + rangevalue * rand(ls, size(URM, 1));
            z = minvalue + rangevalue * rand(ls, size(URM, 1));
        end
    else
        mu = Model.mu;
        bu = Model.bu;
        bi = Model.bi;
        lrate = Model.lrate;
        lambda = Model.lambda;
        useruser = Model.useruser;
        q = Model.q;
        x = Model.x;
        y = Model.y;
        
        if(Model.useruser)
            p = Model.p;
            z = Model.z;
        end
        
        totiterations = Model.iterations + iterations;
        lambdaS = Model.lambdaS;
        lambdaI = Model.lambdaI;
        lambdaU = Model.lambdaU;
        ls = Model.ls;    
        fastBiasInit = Model.fastBiasInit;
        initialize = Model.initialize;
    end
    
    timeHandle = tic;
    display(' - NewNbgr: Koren - started gradient descent');
    if(useruser)
        [buout, biout, qout, xout, yout, pout, zout] = learnFactorModel(URM, mu, bu, bi, iterations, lrate, lambda, q, x, y, p, z);
    else
        [buout, biout, qout, xout, yout] = learnFactorModel(URM, mu, bu, bi, iterations, lrate, lambda, q, x, y);
    end
    display([' - NewNbgr: Koren - Gradient descent completed in ' num2str(toc(timeHandle)) ' sec - ']);
    
    Model.mu = mu;
    Model.bu = buout;
    Model.bi = biout;
    Model.q = qout;
    Model.x = xout;
    Model.y = yout;
    
    if(useruser)
        Model.p = pout;
        Model.z = zout;
    end
    
    Model.lambdaS = lambdaS;
	Model.lambdaI = lambdaI;
    Model.lambdaU = lambdaU;
    Model.lambda = lambda;
    Model.ls = ls;    
    Model.iterations = totiterations;
    Model.lrate = lrate;
    Model.useruser = useruser;
    Model.fastBiasInit = fastBiasInit;
    Model.initialize = initialize;
    
    rmpath(Path);
end