function Model = createModel(URM, Param)
%CREATEMODEL creates the model of the given user-ratinfs matrix using the
%ItemItem_dr Algorithm
%   MODEL = CREATEMODEL(URM, PARAM)
%   has one optional parameter.
%   PARAM.Model if set is the model.
%
%   MODEL is a struct with:
%   MODEL.dr (the model itself)
    
    if(nargin < 1)
        help createModel;
        return;
    end
    
    if(~exist('Param', 'var'))
        dr = URM' * URM;
    else
        if(isfield(Param, 'Model'))
            Model = Param.Model;
            return;
        else
            dr = URM' * URM;
        end
    end
    
    Model.dr = dr; 
end