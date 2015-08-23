function Model = createModel(URM, Param)
%CREATEMODEL creates the model of the given user-ratings matrix using the
%Sarwar Algorithm.
%   MODEL = CREATEMODEL(URM, PARAM)
%   has one optional paramater.
%   PARAM.ls (default 50) specifies the latent Size.
%   PARAM.vt is the vt model to be returned.
%
%   MODEL is a struct with:
%   MODEL.vt (the model itself)
    
    if(nargin < 1)
        help createModel;
        return;
    end
        
    if(isfield(Param, 'ls')) 
        ls = Param.ls;
    else
        ls = 50;
    end
    
    if(isfield(Param, 'vt'))
        Model.vt = Param.vt;
        if(isfield(Param, 'ls') && ls <= size(Model.vt, 1))
            Model.vt = Model.vt(1:ls, :);
        end
    else
        [~, ~, v] = svds(URM, ls);
        Model.vt = v';
    end
end