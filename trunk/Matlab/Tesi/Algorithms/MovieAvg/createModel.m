function Model = createModel(URM, Param)
%CREATEMODEL creates the model of the given user-ratings matrix using the
%MovieAvg Algorithm.
%   MODEL = CREATEMODEL(URM, PARAM)
%   has no optional parameter.
%   PARAM.Path must be set to include the utility directory.
%   PARAM.Model if set is the model used.
%
%   MODEL is a struct with:
%   MODEL.movieAvg (the model itself)
    
    if(nargin < 2)
        help createModel;
        return;
    end
    
    if(isfield(Param, 'Model'))
        Model = Param.Model;
        return;
    end
    
    if(~isfield(Param, 'Path'))
        help createModel;
        return;
    end
    
    Path = [Param.Path filesep 'Utility'];
    addpath(Path);
    
    thandle = tic;
    items = size(URM, 2);
    average = zeros(1, items);
    for i = 1:items
        nonZerosValues = nonzeros(URM(:, i));
        average(i) = mean(nonZerosValues);
        if(mod(i, 100) == 0)
            thandle = displayRemainingTime(i, items, thandle);           
        end
    end
    
    Model.movieAvg = average;
    
    rmpath(Path);
end