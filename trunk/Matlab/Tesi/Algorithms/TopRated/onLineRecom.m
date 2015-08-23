function RecomList = onLineRecom(~, Model, Param)
%ONLINERECOM generates the vector with ratings of a single user with the
%TopRated Algorithm.
%   ONLINERECOM(USERPROFILE, MODEL, PARAM)
%   has one optional parameter.
%   USERPROFILE is the profile of our user. It can be also a row of the urm
%   matrix.
%   MODEL is the one created with createModel function.
%   PARAM.postProcessingFunction handles the post-processing function.
    
    if(nargin < 2)
        help onLineRecom;
        return;
    end
    
    topList = Model.topList;
    RecomList = topList;
    
    if(nargin >= 3)
        if(isfield(Param, 'postProcessingFunction'))
            RecomList = feval(Param.postProcessingFunction, RecomList, Param);
        end
    end
end