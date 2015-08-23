function Model = createModel(URM, Param)
%CREATEMODEL creates the model of the given user-ratings matrix using the
%KorenImplicit Algorithm.
%   MODEL = CREATEMODEL(URM, PARAM)
%   has no optional parameter.
%   PARAM.Path must be set to include the utility directory.
%   PARAM.Model if set is the model used.
%   PARAM.ls (default 50) specifies the latenSize
%   PARAM.alpha (default 40) specifies alpha, i.e. the factor used to
%   compute the confidence of a rating: c_{ui} = 1 + alpha * r_{ui}
%   PARAM.lambda (default 150) specifies the learning rate of each
%   iteration
%   PARAM.iter (default 20) specifies the number of iteration, alternating
%   between computing user- item- factors.
%   PARAM.RatingThreshold (default 0) specifies a threshold for considering
%   a rating as positive, i.e. ratings higher or equal than the threshold
%   are positive, ratings lower than the threshold are considered as
%   missing: p_{ui} = 1 if r_{ui} >= threshold, 0 elsewise.
%
%   MODEL is a struct with:
%   MODEL.X
%   MODEL.Y
%   
%Algorithm 'alternate least-square' inspired by 
%"Collaborative Filtering for Implicit Feedback Dataset"
%Yifan hu, Yehuda Koren, Chris Volinsky [ICDM 2008]
    
    if(nargin < 2)
        help createModel;
        return;
    end
    
    if(isfield(Param, 'Model'))
        Model = Param.Model;
        return;
    end
    
    if(~isfield(Param, 'Path'))
        help createModel;
        return;
    end
    
    Path = [Param.Path filesep 'Utility'];
    addpath(Path);
    
    if(isfield(Param, 'ls'))
        ls = Param.ls;
    else
        ls = 50;
    end
    
    if(isfield(Param, 'alpha'))
        alpha = Param.alpha;
    else
        alpha = 40;
    end
    
    if(isfield(Param, 'lambda'))
        lambda = Param.lambda;
    else
        lambda = 150;
    end
    
    if(isfield(Param, 'iter'))
        iter = Param.iter;
    else
        iter = 20;
    end
    
    if(isfield(Param, 'RatingThreshold'))
        RatingThreshold = Param.RatingThreshold;
    else
        RatingThreshold = 0;
    end
    
    users = size(URM, 1);
    items = size(URM, 2);  

    Y = rand(items, ls);
    X = zeros(users, ls);
    
    C = alpha * URM; % C = 1 + alpha * URM; summing 1 has been moved below in function "computeFeatures" for memory optimization!
    P = URM;
    P(find(P < RatingThreshold)) = 0;
    P = spones(P); 
    
    for iteraz = 1:iter
        tic;
        h = waitbar(0,'Please wait...');        
        YY = Y' * Y;
        for u = 1:users
            xu = computeFeatures(C, Y, YY, P, u, lambda);
            X(u, :) = xu;
            if(mod(u, 1000) == 0)            
                disp(['[' num2str(iteraz) '/' num2str(iter) '] ' num2str(u) ' (' num2str(u / users * 100) '%)   - @ ' num2str(toc / u) 's  - estim = ' num2str(toc * (users - u) / (60 * u)) 'min']);
                waitbar(u / users, h, ['[' num2str(iteraz) '/' num2str(iter) '] ' num2str(u) ' (' num2str(u / users * 100) '%)   - @ ' num2str(toc / u) 's  - estim = ' num2str(toc * (users - u) / (60 * u)) 'min']);
            end
        end
        close(h);
        
        h = waitbar(0,'Please wait...');
        XX = X' * X;
        for i = 1:items
            yi = computeFeatures(C', X, XX, P', i, lambda);
            Y(i, :) = yi;
            if(mod(i, 1000) == 0)
                disp(['[' num2str(iteraz) '/' num2str(iter) '] ' num2str(i) ' (' num2str(i / items * 100) '%)   - @ ' num2str(toc / i) 's  - estim = ' num2str(toc * (items - i) / (60 * i)) 'min']);
                waitbar(i / items, h, ['[' num2str(iteraz) '/' num2str(iter) '] ' num2str(i) ' (' num2str(i / items * 100) '%)   - @ ' num2str(toc / i) 's  - estim = ' num2str(toc * (items - i) / (60 * i)) 'min']);
            end
        end        
        close(h);
        disp([num2str(iteraz) ' - ' num2str(toc)]);
    end
    
    Model.X = X;     
    Model.Y = Y;
    
    rmpath(Path);
end