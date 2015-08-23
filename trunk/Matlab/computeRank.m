function Rank = computeRank(TestData)
    if(size(TestData, 2) > 0)
        r = zeros(1, size(TestData, 2));
        rating = zeros(1, size(TestData, 2));
        
        for a = 1:size(TestData, 2) 
            r(a) = TestData(a).pos; 
            rating(a) = TestData(a).rating; 
        end
        
	    Rank = r(rating ~= -1);
    else
         Rank = -1;
    end
end