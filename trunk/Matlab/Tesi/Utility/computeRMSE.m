function RMSE = computeRMSE(TestData, URM)
    if(size(TestData, 2) > 0)
        tmpSum = 0;
        tmpCount = 0;
        
        for i = 1:size(TestData, 2) 
            estimatedrating = TestData(i).rating; 
            actualrating = URM(TestData(i).user, TestData(i).item);
            
            if(estimatedrating ~= -1 && ~isnan(estimatedrating))
                tmpSum = tmpSum + ((estimatedrating - actualrating) ^ 2);
                tmpCount = tmpCount + 1;
            end
        end
        RMSE = sqrt(tmpSum / tmpCount);	    
    else
         RMSE = -1;
    end
end