function [URM] = normalizeColsMatrix (URM)
    display ('started URM normalization');
    splittingSize=100;
    
    items=size(URM,2);
    numSplittings=items/splittingSize;
    
    for i=1:ceil(numSplittings)
        beginInterval=splittingSize*(i-1) +1;
        endInterval=splittingSize*(i);
        if (endInterval>items), endInterval=items; end
        URM(:,beginInterval : endInterval)= normalizeWordsMatrix(URM(:,beginInterval : endInterval),2);
        if (mod(i,10)==0) 
            display(i);
        end
    end
end
