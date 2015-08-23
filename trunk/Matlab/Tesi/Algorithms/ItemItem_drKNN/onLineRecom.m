function RecomList = onLineRecom(UserProfile, Model, Param)
%ONLINERECOM generates the vector with ratings of a single user with the
%ItemItem_drKNN Algorithm.
%   ONLINERECOM(USERPROFILE, MODEL, PARAM)
%   has one optional parameter.
%   USERPROFILE is the profile of our user. It can be also a row of the urm
%   matrix.
%   MODEL is the one created with createModel function.
%   PARAM is optional.
%   PARAM.postProcessingFunction handles the post-processing function

    II = Model.II;
    RecomList = UserProfile * II;
    
    if(nargin >= 3)
        if(isfield(Param, 'postProcessingFunction'))
            RecomList = feval(Param.postProcessingFunction, RecomList, Param);
        end
    end
end