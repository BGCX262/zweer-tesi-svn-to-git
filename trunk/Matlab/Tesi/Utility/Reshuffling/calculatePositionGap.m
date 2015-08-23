function GapList = calculatePositionGap(List, OldList, NewList, Abs)
%CALCULATEPOSITIONGAP(LIST, OLDLIST, NEWLIST, ASS) calculates the gap
%between two lists
%   One optional parameter.
%   If ABS is set and equal to 'perc' the calculation is made in a
%   percentual mode.
    if(nargin < 3)
        help calculatePositionGapAss
        return;
    end
    
    if(exist('Abs', 'var') == 0)
        Abs = 'abs';
    end
    
    GapList = zeros(1, length(List));
    
    for n = 1:length(List)
        [~, j] = sort(-OldList);
        [~, k] = sort(-NewList);
        PosOld = find(j == List(n));
        PosNew = find(k == List(n));
        Gap = PosOld - PosNew;
        
        if(strcmp(Abs, 'perc') == 1)
            if(PosOld == PosNew)
                Gap = 0;
            elseif(PosOld > PosNew)
                Gap = (PosOld - PosNew) / PosOld;
            else
                Gap = (PosNew - PosOld) / PosNew;
                Gap = -Gap;
            end 
        end
        
        GapList(n) = Gap;
    end
    GapList = GapList';
end