function [Positive, Negative] = extractTestSets(URM, PercentagePos, PercentageNeg, Threshold, ProfileLength, UnpopularThreshold, KFolder, ItemsViews)
%EXTRACTTESTSETS extracts the given percentage of positive and negative
%testsets from the given urm matrix.
%   [POSITIVE, NEGATIVE] = EXTRACTTESTSETS(URM, P, N, T, PL, UNPOP, K, IV)
%   has 5 optional parameters.
%   URM is the matrix from which the testsets are extracted.
%   P (default 1) is the percentage of positive tests to be extracted.
%   N (default -1) is the percentage of negative tests to be extracted.
%   When set to a negative value it doesn't extract negative testsets.
%   T (default -1) ratings greater than T are positive, and ratings less
%   than T are negative. If it is set to -1 it counts also the userAverage.
%   PL (default 0) is the profile length. If it is a scalar it creates test
%   sets discarding users with less then 'PL' ratings, if it is a 2-element
%   vector, it selects only users with a number of ratings in the range
%   [PL(1) PL(2)].
%   UNPOP (default -1) is the unpopular threshold. If it is set to a
%   positive number it discards popular items, which are the items in the
%   top N, where N is UNPOP.
%   K (default 1) is a positive scalar indicating that testsets must be
%   created for each fold, where K is the number of folds.
%   IV (default the number of values in the urm matrix) is the distribution
%   of item's views.
    
    if(nargin < 1)
        help extractTestSets;
        return;
    end
    
    if(~exist('PercentagePos', 'var'))
        PercentagePos = 1;
    end
    
    if(~exist('PercentageNeg', 'var'))
        PercentageNeg = -1;
    end
    
    if(~exist('Threshold', 'var'))
        Threshold = -1;
    end
    
    if(~exist('ProfileLength', 'var'))
        ProfileLength = 0;
    elseif(length(ProfileLength) > 2)
        ProfileLength = 0;
    end
    
    if(~exist('UnpopularThreshold', 'var'))
        UnpopularThreshold = -1;
    end
    
    if(~exist('KFolder', 'var'))
        KFolder = 1;
    end
    
    if(~exist('ItemsViews', 'var'))
        ItemsViews = full(sum(spones(URM), 1));
    elseif(ItemsViews == 0)
        ItemsViews = full(sum(spones(URM), 1));
    elseif(length(ItemsViews) ~= size(URM, 2))
        error('ItemsViews has a wrong size!');
    end
    
    numUsers = size(URM, 1);
    numRowsToTest = floor(numUsers / KFolder);
    
    Positive = zeros(1, KFolder);
    Negative = zeros(1, KFolder);
    
    for i = 1:KFolder
        maxIndexRowTest = numRowsToTest * i;
        URMTest = URM(maxIndexRowTest - numRowsToTest + 1:maxIndexRowTest, :);
        
        [Pos, Neg] = extractTestSetsIn(URMTest, PercentagePos, PercentageNeg, UnpopularThreshold, ItemsViews, ProfileLength, Threshold);
        
        Pos.i = Pos.i + maxIndexRowTest - numRowsToTest;
        Neg.i = Neg.i + maxIndexRowTest - numRowsToTest;
        
        Positive(i) = Pos;
        Negative(i) = Neg;
    end
end

function [Positive, Negative] = extractTestSetsIn(URMTest, PercentagePos, PercentageNeg, UnpopularThreshold, ItemsViews, ProfileLength, Threshold)
    if(nargin < 7)
        return;
    end
    
    UsersViews = full(sum(spones(URMTest), 2));
    
    if(length(ProfileLength) == 2)
        ViewsThresholdInf = ProfileLength(1);
        ViewsThresholdSup = ProfileLength(2);
    else
        ViewsThresholdInf = ProfileLength;
        ViewsThresholdSup = +Inf;
    end
    
    if(UnpopularThreshold > 0)
        OrderedItemsViews = sort(ItemsViews, 2, 'descend');
        ViewsThreshold = OrderedItemsViews(UnpopularThreshold);
    else
        ViewsThreshold = max(ItemsViews) + 1;
    end
    
    if(PercentageNeg < 0)
        [PosItmp, PosJtmp] = find(URMTest);
        
        if(UnpopularThreshold < 0)
            indexPos = length(PosItmp);
        else
            PosI = zeros(size(PosItmp));
            PosJ = zeros(size(PosJtmp));
            
            indexPos = 0;
            
            for i = 1:length(PosItmp);
                user = PosItmp(i);
                item = PosJtmp(i);
                
                if(ItemsViews(item) < ViewsThreshold && UsersViews(user) >= ViewsThresholdInf && UsersViews(user) <= ViewsThresholdSup)
                    indexPos = indexPos + 1;
                    PosI(indexPos) = user;
                    PosJ(indexPos) = item;
                end
            end
        end
        
        numPos = ceil(indexPos * PercentagePos);
        posIndex = randsample(indexPos, numPos);
        Positive.i = PosI(posIndex);
        Positive.j = PosJ(posIndex);
        Negative.i = [];
        Negative.j = [];
    else
        userAvg = zeros(1, size(URMTest, 1));
        itemAvg = zeros(1, size(URMTest, 2));
        skipped = [];
        
        h = waitbar(0, 'Please wait...');
        
        for i = 1:size(URMTest, 1)
            if(~isempty(find(URMTest(i, :))))
                userAvg(i) = mean(URMTest(i, find(URMTest(i, :))));
            else
                skipped = [skipped; i];
            end
            
            if mod(i, 100) == 0
                waitbar(i / size(URMTest, 1), h, num2str(i))
            end
        end
        
        close(h);
        drawnow;
        
        [URMi, URMj] = find(URMTest);
        
        posI = zeros(size(URMi));
        posJ = zeros(size(URMi));
        negI = zeros(size(URMi));
        negJ = zeros(size(URMi));
        
        indexPos = 0;
        indexNeg = 0;
        
        for i = 1:length(URMi)
            user = URMi(i);
            item = URMj(i);
            rating = URM(user, item);
            isAcceptable = ((UnpopularThreshold < 0 || ItemsViews(item) < ViewsThreshold) && UsersViews(user) >= ViewsThresholdInf && UsersViews(user) <= ViewsThresholdSup);
            
            if(Threshold == -1)
                isPositive = (rating >= 3 && rating >= userAvg(user));
                isNegative = (rating < 3  && rating <  userAvg(user));
            else
                isPositive = (rating >= Threshold);
                isNegative = (rating <  Threshold);
            end
            
            if(isPositive && isAcceptable)
                indexPos = indexPos + 1;
                posI(indexPos) = user;
                posJ(indexPos) = item;
            elseif(isNegative && isAcceptable)
                indexNeg = indexNeg + 1;
                negI(indexNeg) = user;
                negJ(indexNeg) = item;
            end
        end
        
        posI = posI(1:indexPos);
        posJ = posJ(1:indexPos);
        negI = negI(1:indexNeg);
        negJ = negJ(1:indexNeg);
        
        if(PercentageNeg == 1 && PercentagePos == 1)
            Positive.i = posI;
            Positive.j = posJ;
            Negative.i = negI;
            Negative.j = negJ;
            return;
        end
        
        numPos = ceil(indexPos * PercentagePos);
        numNeg = ceil(indexNeg * PercentageNeg);
        
        posIndex = randsample(indexPos, numPos);
        negIndex = randsample(indexNeg, numNeg);
        
        Positive.i = posI(posIndex);
        Positive.j = posJ(posIndex);
        Negative.i = negI(negIndex);
        Negative.j = negJ(negIndex);
    end
end