function FinalList = antiReshuffling(Parameters)
%ANTIRESHUFFLING(PARAMETERS) computes a new list from the two lists
%computed in different temporal instants.
%   No optional parameter.
%   PARAMETERS is a struct of parameters:
%       - OldList: the first list.
%       - NewList: the second list.
%       - Profile: the user profile when the second list is generated.
%       - Metric: which metric the algorithm will use ('gapass' or
%       'gapperc').
%       - Threshold: the threshold used by the algorithm.
%       - Comparison: 1: it uses the "method2"
%                     0: it doesn't use the "method2"
%       - Length: legth of the top-n list FinalList
    FinalList = [];
    
    if(isempty('Parameters.OldList'))
        help antiReshuffling
        return;
    end
    
    if(isempty('Parameters.NewList'))
        help antiReshuffling
        return;
    end
    
    if(isempty('Parameters.Profile'))
        help antiReshuffling
        return;
    end
    
    if(length(Parameters.OldList) ~= length(Parameters.NewList))
        disp('The two lists have different legth. Please check it!');
        return;
    end
	
    if(exist('Parameters.Metric', 'var') == 0)
        disp('The metric isn''t set. Autosetting to ''gapass''');
        Parameters.Metric = 'gapass';
    end
    
	if(strcmp(Parameters.Metric, 'gapass') == 0) && (strcmp(Parameters.Metric, 'gapperc') == 0)
        disp('The metric isn''t set. Autosetting to ''gapass''');
        Parameters.Metric = 'gapass';
	end
	
	if(exist('Parameters.Threshold', 'var') == 0)
		if(strcmp(Parameters.Metric, 'gapass') == 1)
			Parameters.Threshold = 0.2;
        elseif(strcmp(Parameters.Metric, 'gapperc') == 1)
			Parameters.Threshold = 0.9;
		end
	end
	
	if(strcmp('Parameters.Metric', 'gapass') == 1 && exist('Parameters.Comparison', 'var') == 0)
		Parameters.Comparison = 1;
    elseif(strcmp(Parameters.Metric, 'gapperc') == 1 && exist('Parameters.Comparison', 'var') == 0)
		Parameters.Comparison = 0;
	end
	
	if(exist('Parameters.Length', 'var') == 0)
		disp('The length of the Final List isn''t set. Autosetting to 10');
		Parameters.Length = 10;
	end
	
    [~, j] = sort(-Parameters.OldList);
    [~, k] = sort(-Parameters.NewList);
    
	% finding incoming and outcoming records
    [Incoming, Outcoming, Change] = checkInOut(j(1 : Parameters.Length), k(1 : Parameters.Length));
    
	% if no changes happened, returning the new one, otherwise applying the
	% antiReshuffling
    if(Change == 0)
        FinalList = Parameters.NewList;
    else
        FinalList = getFinalList(Parameters.OldList, Parameters.NewList, Incoming, Outcoming, Parameters.Metric, Parameters.Threshold, Parameters.Comparison);
    end
    
    FinalList(find(Parameters.Profile)) = -inf;
end