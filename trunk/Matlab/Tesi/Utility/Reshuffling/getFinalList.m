function FinalList = getFinalList(OldList, NewList, Incoming, Outcoming, Metric, Threshold, Comparison)
%GETFINALLIST(OLDLIST, NEWLIST, INCOMING, OUTCOMING, METRIC, THRESHOLD,
%COMPARISON) returns the list containing the final reccomendations, after
%invoking the functions to calculate gaps and changes.
    if(nargin ~= 7)
        help getFinalList
        return;
    end
    
    if(strcmp(Metric, 'gapass') == 1)
       Threshold = Threshold * length(OldList);
       IncomingGap = calculatePositionGap(Incoming, OldList, NewList);
       OutcomingGap = calculatePositionGap(Outcoming, OldList, NewList);
    elseif(strcmp(Metric, 'gapperc') == 1)
       IncomingGap = calculatePositionGap(Incoming, OldList, NewList, 'perc');
       OutcomingGap = calculatePositionGap(Outcoming, OldList, NewList, 'perc');
    end
    
    FinalList = checkList(OldList, NewList, Incoming, Outcoming, IncomingGap, OutcomingGap, Threshold, Comparison);
end