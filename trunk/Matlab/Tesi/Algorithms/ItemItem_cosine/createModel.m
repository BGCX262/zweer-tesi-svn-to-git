function Model = createModel(URM, Param)
%CREATEMODEL creates the model of the given user-ratings matrix using the
%ItemItem_Cosine Algorithm.
%   MODEL = CREATEMODEL(URM, PARAM) 
%   has no optional parameter.
%   PARAM.Path must be set to include the utility directory.
%   If PARAM.Model is set, it uses the model specified in it.
%
%   MODEL is a struct with:
%   MODEL.drCos (the model itself)
    
    if(nargin < 2)
        help createModel
        return;
    end
    
    if(isfield(Param, 'Model'))
        Model = Param.Model;
        return;
    end
    
    if(isfield(Param, 'Path'))
        help createModel
        return;
    end
    
    Path = [Param.Path filesep 'Utility'];
    addpath(Path);
    
    URM = normalizeColsMatrix(URM);
    Model.drCos = URM' * URM;
    
    rmpath(Path);
end