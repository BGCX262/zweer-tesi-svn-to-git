function timeHandle = displayRemainingTime(computedElements, elementsToCompute, timeHandle)
%DISPLAYREMAININGTIME tries to compute the remaining time for the task to
%complete and displayes it.
%   DISPLAYREMAININGTIME(COMPUTEDELEMENTS, ELEMENTSTOCOMPUTE, TIMEHANDLE)
%   has no optional parameters.
    
    if(nargin < 3)
        help displayRemainingTime
        return;
    end
    
    try
        tend = toc(timeHandle);
    catch e
        timeHandle = tic;
        return;
    end
    
    perItemTime = (tend) / computedElements;
    remainingTime = perItemTime * (elementsToCompute - computedElements);        
    disp([num2str(computedElements) '/' num2str(elementsToCompute) ' - remainingTime for task: ' num2str(round(remainingTime)) ' seconds']);
end