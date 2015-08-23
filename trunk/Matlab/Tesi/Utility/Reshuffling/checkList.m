function FinalList = checkList(OldList, NewList, Incoming, Outcoming, IncomingGap, OutcomingGap, Threshold, Comparison)
%CHECKLIST(OLDLIST, NEWLIST, INCOMING, OUTCOMING, INCOMINGGAP,
%OUTCOMINGGAP, THRESHOLD, COMPARISON) evaluates the incoming and outcoming
%records in relation with the metric and the threshold used. It applyes
%"method2" in relation to the metric used

    % building the two matrices with record and their relative gap
    IncomingMatrix = cat(2, Incoming, IncomingGap);
    OutcomingMatrix = cat(2, Outcoming, OutcomingGap);

    % sorting the two matrices, the Incoming one in descending order according
    % to the gap, the Outcoming one in ascending order according to the gap
    IncomingMatrix = sortByColumn(IncomingMatrix, 2, 'desc');
    OutcomingMatrix = sortByColumn(OutcomingMatrix, 2);

    % METHOD1 - PART 1
    % taking the items of the incoming list that exceed the threshold and
    % putting them in the incoming candidate list
    IncomingMatrix(find(IncomingMatrix(:, 2) >= Threshold), 1:2) = -inf;
    k = length(find(IncomingMatrix(:, 1) == -inf));

    % METHOD1 - PART 2
    % controlling if there are elements in the incoming candidate list. If so
    % taking elements from the outcoming list with a low gap and putting them
    % in the outcoming candidate list. After that controlling which elements
    % has a gap smaller than the threshold and putting them in the outcoming
    % candidate list
    if(k > 0)
        for n = 1:k
            OutcomingMatrix(n, :) = -inf;
        end
        
        h = 0;
        
        for n = 1:size(OutcomingMatrix, 1)
            if(OutcomingMatrix(n, 2) < -Threshold)
                h = h + 1;
                OutcomingMatrix(n, :) = -inf;
            end
        end
        
        if(h > 0)
            l = size(OutcomingMatrix, 1);
            for n = 1:h
                IncomingMatrix(n, :) = -inf;
            end
        end
    end % if(k > 0)
    
    % deleting from the Incoming and Outcoming lists the candidates
    ko = find(IncomingMatrix(:, 2) == -inf);
    IncomingMatrix(ko, :) = [];
    
    ko = find(OutcomingMatrix(:, 2) == -inf);
    OutcomingMatrix(ko, :) = [];
    
    % applying the comparison
    if(Comparison == 1)
        h = 1;
        for n = 1:size(IncomingMatrix, 1)
            if((IncomingMatrix(n, 2) - OutcomingMatrix(n, 2)) >= ((Threshold) / 2))
                h = h + 1;
                IncomingMatrix(n, :) = -inf;
                OutcomingMatrix(n, :) = -inf;
            end
        end
        
        % deleting from the Incoming and Outcoming lists the candidates
        ko = find(IncomingMatrix(:, 2) == -inf);
        IncomingMatrix(ko, :) = [];

        ko = find(OutcomingMatrix(:, 2) == -inf);
        OutcomingMatrix(ko, :) = [];
    end % if(Comparison == 1)
    
    % exchanging the score and returning the final list
    for n = 1:l
        IncomingMatrix(n, 2) = NewList(1, IncomingMatrix(n, 1));
        OutcomingMatrix(n, 2) = NewList(1, OutcomingMatrix(n, 1));
    end
    
    IncomingMatrix = sortByColumn(IncomingMatrix, 2, 'desc');
    OutcomingMatrix = sortByColumn(OutcomingMatrix, 2, 'desc');
    
    for n = 1:l
        temp = NewList(1, IncomingMatrix(n, 1));
        NewList(1, IncomingMatrix(n, 1)) = NewList(1, OutcomingMatrix(n, 1));
        NewList(1, OutcomingMatrix(n, 1)) = temp;
    end
    
    FinalList = NewList;
    
end