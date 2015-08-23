function Model = createModel(~, Param)
%CREATEMODEL creates the model of the given user-rating matrix using the
%IsoCosine Algorithm.
%   MODEL = CREATEMODEL(URM, PARAM)
%   has no optional parameter.
%   PARAM.Path must be set to include the utility directory.
%   PARAM.Model if set is the model used.
%   PARAM.ls is the latent size.
%   PARAM.itemModel must be set and it is the projItem matrix = s * v' (not
%   necessary normalized).
%
%   MODEL is a struct with:
%   MODEL.dnorm (the model itself)
    
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
    
    if(~isfield(Param, 'itemModel'))
        help createModel;
        return;
    end
    
    Path = [Param.Path filesep 'Utility'];
    addpath(Path);
    
    d = Param.itemModel;
    
    if(isfield(Param, 'ls'))
        ls = Param.ls;
    else
        ls = size(d, 1);
    end
    
    d = d(1:ls, :); 
    dnorm = normalizeWordsMatrix(d, 2);
    Model.dnorm = dnorm;
    
    rmpath(Path);
end