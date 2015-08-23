function Model = createModel(URM, Param)
%CREATEMODEL creates the model of the given user-ratings matrix using the
%ItemItem_CosineKNN Algorithm.
%   MODEL = CREATEMODEL(URM, PARAM)
%   has no optional parameter.
%   PARAM.Path must be set to include the utility directory.
%   PARAM.Model if set return as the Model of the function (must contain
%   the dr matrix and the bias).
%   PARAM.drCos if set contains the dr matrix (URM' * URM).
%   PARAM.memoryProblem (default false) whether it must use the optimized
%   version for big sparse matrices.
%   PARAM.SimilarityShrinkage (default false) enable shrinking for cosine
%   similarity (shrinking factor is lambdaS).
%   PARAM.lambdaS (default 100) is the shrinking factor.
%   PARAM.lambdaI (default 25)
%   PARAM.lambdaU (default 10)
%   PARAM.knn (default the number of URM's cols) is the number of K to
%   consider in dr matrix.
%   PARAM.computeBaseline (default false) whether to compute mu, bu and bi
%
%   MODEL is a struct with:
%   MODEL.II (the model itself)
%   MODEL.SimilarityShrinkage (whether the shrinking is applied)
    
    if(nargin < 2)
        help createModel
        return;
    end
    
    if(isfield(Param, 'Model'))
        Model = Param.Model;
        return;
    end
    
    if(~isfield(Param, 'Path'))
        help createModel
        return;
    end
    
    Path = [Param.Path filesep 'Utility'];
    addpath(Path);
    
    if(~isfield(Param, 'memoryProblem'))
        Param.memoryProblem = false;
    end
    
    if(isfield(Param, 'SimilarityShrinkage'))
        if(islogical(Param.SimilarityShrinkage))
            SimilarityShrinkage = Param.SimilarityShrinkage;
        else
            SimilarityShrinkage = false;
        end
        
        if(isfield(Param, 'lambdaS'))
            lambdaS = Param.lambdaS;
        else
            lambdaS = 100;
        end
    else
        SimilarityShrinkage = false;
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
					
    if(isfield(Param, 'drCos'))
        if(~Param.memoryProblem)
            try
                drCos = full(Param.drCos);
            catch e
            	Param.memoryProblem = true; 
            end                
        end
    else 
        URM = normalizeColsMatrix(URM);
        
        if (~Param.memoryProblem)
            try
                drCos = full(URM' * URM);
            catch e
                Param.memoryProblem = true; 
            end
        end
    end
    
    if(isfield(Param, 'knn'))
        knn = Param.knn;
    else 
        knn = size(URM, 2) - 1;
    end
    
    
    timeHandle = tic;
    
    if(~Param.memoryProblem)
        tic;
        if(knn < size(drCos, 2))
            for i = 1:size(drCos, 2)
                drCos(i, i) = 0;
            end
            
            II = sparse(size(drCos, 1), size(drCos, 2));
            
            for i = 1:size(II, 2)
                colItem = drCos(:, i);
                [~, c] = sort(colItem, 'descend');
                itemToKeep = c(1:knn);
                II(itemToKeep, i) = drCos(itemToKeep, i);
            end
        else
            II = drCos;
        end
        
        disp(['Cosine IIknn: knn-filtering completed in ' num2str(toc) ' seconds']);
    else
        tic;
        if(knn >= size(URM, 2))
            error('MEMORY ISSUE: knn must be smaller');
        end
        
        II = sparse(size(URM, 2), size(URM, 2));
        
        splitSize = 500;
        splitNum = ceil(size(II, 2) / splitSize);
        
        for j = 1:splitNum
            maxNumOfCols = min([j * splitSize, size(II, 2)]);
            colIndexes = splitSize * (j - 1) + 1:maxNumOfCols;
            
            commonEl = false;
            
            try
                [colItems, commonElementsC] = provaCosShrink(URM, URM(:, colIndexes));
                commonEl = true;
            catch e
                disp(e);
                disp('C-compiled code failed! --> using approximated matlab function');
                colItems = (URM' * URM(:, colIndexes));
            end
            
            colItems = full(colItems);
            colItems(find(isnan(colItems))) = 0;
            
            if(SimilarityShrinkage)
                if(~commonEl)
                    commonElements = zeros(size(URM, 2), length(colIndexes));
                    otherSplitSize = 100;
                    otherSplitNum = ceil(size(URM, 2) / otherSplitSize);
                    
                    for a = 1:otherSplitNum
                        otherColMax = min([a * otherSplitSize, size(URM, 2)]);
                        otherColIndexes = otherSplitSize * (a - 1) + 1:otherColMax;
                        for b = 1:length(colIndexes)
                            commonElements(otherColIndexes, b) = sum(spones(URM(:, otherColIndexes) .* (URM(:, colIndexes(b)) * ones(1, length(otherColIndexes)))), 1);
                        end
                    end
                else
                    commonElements = commonElementsC;
                end
                commonElements = commonElements ./ (commonElements + lambdaS);
                colItems = colItems .* commonElements;
            end
            
            [~, c] = sort(full(colItems), 'descend');
            
            itemsToKeep = sub2ind([size(colItems, 1) size(colItems, 2)], c(1:knn+1, :), [[1:length(colIndexes)]' * ones(1, knn + 1)]');
            filteredColItems = zeros(size(colItems));
            filteredColItems(itemsToKeep) = colItems(itemsToKeep);
            II(:, colIndexes) = filteredColItems;
            
            if(mod(j, 1) == 0)
                timeHandle = displayRemainingTime(maxNumOfCols, size(II, 2), timeHandle);
            end
        end
        
        II(sub2ind(size(II), [1:size(II, 2)], [1:size(II, 2)])) = 0;
        
        disp(['Cosine IIknn: multiplication and knn-filtering completed in ' num2str(toc) ' seconds']);
    end
    
    if(isfield(Param, 'computeBaseline'))
        if(islogical(Param.computeBaseline))
            if(Param.computeBaseline)
                [Model.mu, Model.bu, Model.bi] = computeRatingBiases(URM, lambdaU, lambdaI);
            end
        end
    end
    
    Model.II = II;
    Model.SimilarityShrinkage = SimilarityShrinkage;
    
    rmpath(Path);
end