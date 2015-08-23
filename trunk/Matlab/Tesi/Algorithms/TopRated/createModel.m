function Model = createModel(URM, Param)
%CREATEMODEL creates the model of the given user-ratings matrix using the
%TopRated Algorithm.
%   MODEL = CREATEMODEL(URM, PARAM)
%   has one optional parameters.
%   PARAM.Model is the model used.
%
%   MODEL is a struct with:
%   MODEL.topList (the model itself)
    
    if(nargin < 1)
        help createModel;
        return;
    end
    
    if(exist('Param', 'var'))
        if(isfield(Param, 'Model'))
            Model = Param.Model;
            return;
        end
    end
    
    URM = spones(URM);
    topList = sum(URM, 1);
    Model.topList = topList;
end