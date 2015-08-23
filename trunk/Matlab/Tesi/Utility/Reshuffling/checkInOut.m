function [Incoming, Outcoming, Change] = checkInOut(OldList, NewList)
%CHECKINOUT(OLDLIST, NEWLIST) finds the differences between two lists,
%specifying which records have entered the list and which records have left
%the list.
%   [INCOMING, OUTCOMING, CHANGE] = CHECKINOUT(OLDLIST, NEWLIST)
%   No optional parameters.
%   The return values are:
%       - INCOMING: the list of all the records that have entered the list.
%       - OUTCOMING: the list of all the records that have left the list.
%       - CHANGE: (0 / 1) if any record has entered or left the list. (If
%       CHANGE is seto to 0, INCOMING and OUTCOMING are 0-length vectors)
    if(nargin ~= 2)
        help checkInOut
        return;
    end
    
    k = 1;
    Incoming(k) = -1;
    Outcoming(k) = -1;
    Change = 0;
    for i = 1:length(OldList)
        Actual = OldList(i);
        Found = 0;
        for j = 1:length(NewList)
            if(Actual == NewList(j)) 
                Found = 1;
                break;
            end
        end
        
        if(Found == 0)
            Outcoming(k) = Actual;
            k = k + 1;
        end
    end
    
    k = 1;
    
    for i = 1:length(NewList)
        Actual = NewList(i);
        Found = 0;
        for j = 1:length(OldList)
            if(Actual == OldList(j)) 
                Found = 1;
                break;
            end
        end
        
        if(Found == 0)
            Incoming(k) = Actual;
            k = k + 1;
        end
    end
    
    if(Outcoming(1) ~= -1)
        Change = 1;
    end
    
    Incoming = Incoming';
    Outcoming = Outcoming';
end