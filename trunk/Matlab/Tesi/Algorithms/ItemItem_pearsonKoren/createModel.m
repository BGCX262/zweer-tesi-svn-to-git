function Model = createModel(URM, Param)
%CREATEMODEL creates the model of the given user-rating matrix using the
%ItemItem_PearsonKoren Algorithm.
%   MODEL = CREATEMODEL(URM, PARAM)
%   has no optional parameter.
%   PARAM.Path must be set to include the utility directory.
%   PARAM.Model if set return as the Model of the function (must contain
%   the dr matrix and the bias).
%   PARAM.knn (default 200) is the number of K to
%   consider in dr matrix.
%   PARAM.lambdaS (default 100) is the shrinking factor for s_{ij}
%   PARAM.lambdaI (default 25) is the shrinking factor for mean item b_{i}
%   PARAM.lambdaU (default 10) is the shrinking factor for mean user b_{u}
%   PARAM.Cdisabled whether to disable the C-compiled execution
%   PARAM.similarityOnResidual (default 1) whether to compute similarity on
%   residuals' URM ot on the original one.
%
%   The MODEL returned is:
%   MODEL.mu is the average rating
%   MODEL.bu is the vector od the average rating for each user
%   MODEL.bi is the vector of the average rating for each item
%   MODEL.dr id the item-item similarity matrix
%   MODEL.lambdaS is the shrinking factor used for s_{ij}
%   MODEL.lambdaI is the shrinking factor used for mean item b_{i}
%   MODEL.lambdaU is the shrinking factor used for mean user b_{u}
%   MODEL.knn is the Knn used
%   MODEL.similarityOnResidual whether the Similarity On Residual is used
%
%Reference paper: 
%"Factor in the Neighbors: Scalable and Accurate Collaborative Filtering"
%Yehuda Koren, AT&T Labs - Research
    
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
    
    if(isfield(Param, 'knn'))
        knn = Param.knn;
    else 
        knn = 200;
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
    
    Cdisabled = false;
    if(isfield(Param, 'Cdisabled'))
        if(islogical(Param.Cdisabled))
            Cdisabled = Param.Cdisabled;
        end
    end
    
    similarityOnResidual = true;
    if(isfield(Param, 'similarityOnResidual'))
        similarityOnResidual = Param.similarityOnResidual;
    end
    if(~similarityOnResidual && isempty(inputname(1)))
        urmSimilarity = URM;
    else
        urmSimilarity = [];
    end
    
    Path = [Param.Path filesep 'Utility'];
    addpath(Path);
    
    tic
    URMt = URM';
    display(['Pearson IIkoren: transpose computed in ' num2str(toc) ' seconds']);
    
    
    display(' - Pearson IIkoren: computing biases - ');
    mu = full(sum(sum(URM, 1), 2));
    mu = mu / nnz(URM);
    nnzI = zeros(1, size(URM, 2));
    nnzU = zeros(1, size(URM, 1));
    
    timeHandleBiases = tic;
    for i = 1:length(nnzI)
        nnzI(i) = nnz(URM(:, i)); 
        if(mod(i, 2000) == 0),
            displayRemainingTime(i, length(nnzI), timeHandleBiases);           
        end       
    end
    bi = (sum(URM, 1) - mu * (nnzI)) ./ (lambdaI + nnzI);
    
    for i = 1:length(nnzU)
        nnzU(i) = nnz(URMt(:, i)); 
        if(mod(i, 20000) == 0),
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
        
        if (mod(i, 50000) == 0),
            displayRemainingTime(i, splitNum, timeHandleBiases);           
        end          
    end
    bu = (sum(URM, 2)' - mu * nnzU - tosub) ./ (lambdaU + nnzU);
    
    clear URMt;
    
    display(' - Pearson IIkoren: normalize URM - ');
    timeHandleNormalize = tic;
    successful = false;
    if(~Cdisabled)
        try
            URM = provaNormalize(URM, mu + bi);
            successful = true;
        catch e
            display('C-compiled code failed!');
            display(e);
        end
    end
    if(~successful)
        for i = 1:length(bi)
            itemVector = URM(:, i); 
            nnzIndexes = find(itemVector);
            URM(nnzIndexes, i) = itemVector(nnzIndexes) - mu - bi(i);
            if(mod(i, 1000) == 0),
                displayRemainingTime(i, length(bi), timeHandleNormalize);           
            end       
        end
    end
    display(['Item bias normalized in ' num2str(toc(timeHandleNormalize)) ' seconds']);    
    
    tic;
    %display('Pearson IIkoren: computing URM transpose');
    URMt = URM';
    clear URM;
    display(['Pearson IIkoren: transpose computed in ' num2str(toc) ' sec']);
    timeHandleNormalize = tic;
    
    for i = 1:length(bu)
        userVector = URMt(:, i); 
        nnzIndexes = find(userVector);
        URMt(nnzIndexes, i) = userVector(nnzIndexes) - bu(i);
        if (mod(i, 50000) == 0)
            displayRemainingTime(i, length(bu), timeHandleNormalize);           
        end       
    end    

    tic;    
    %display('Pearson IIkoren: computing URM'' transpose');
    URM = URMt';
    display(['Pearson IIkoren: URM'' transpose computed in ' num2str(toc) ' sec']);    
    clear URMt;  

    if(~similarityOnResidual)
        display('Pearson-r computed on original URM');
        if(isempty(urmSimilarity))
            II = computePearsonSimilarity(evalin('caller', inputname(1)), knn, lambdaS, Cdisabled);
        else
            II = computePearsonSimilarity(urmSimilarity, knn, lambdaS, Cdisabled);
        end
    else
        display('Pearson-r computed on residuals');
        II = computePearsonSimilarity(URM, knn, lambdaS, Cdisabled);
    end

    Model.mu = mu;
    Model.bu = bu;
    Model.bi = bi;
    Model.dr = II; 
    
    Model.lambdaS = lambdaS;
	Model.lambdaI = lambdaI;
    Model.lambdaU = lambdaU;    
    Model.knn = knn;    
    Model.similarityOnResidual = similarityOnResidual;
    
    rmpath(Path);
end