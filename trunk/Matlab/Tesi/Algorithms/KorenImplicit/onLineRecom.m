function [RecomList] = onLineRecom(UserProfile, Model, Param)
%ONLINERECOM generates the vector with ratings of a single user with the
%KorenImplicit Algorithm.
%   ONLINERECOM(USERPROFILE, MODEL, PARAM)
%   has one optional parameter.
%   USERPROFILE (different from other algorithms) is a scalar, identifying
%   the row of the URM matrix representing the user to be recommended.
%   MODEL is the one created with createModel function.
%   PARAM.postProcessingFunction handles the post-processing function
    
    if(nargin < 2)
        help onLineRecom;
        return;
    end
    
    if(~isscalar(UserProfile))
        help onLineRecom;
        return;
    end
    
    X = Model.X;     
    Y = Model.Y;
    userID = UserProfile;
    RecomList = X(userID,: ) * Y';
    
    if(nargin >= 3)
        if(isfield(Param, 'postProcessingFunction'))
            RecomList = feval(Param.postProcessingFunction, RecomList, Param);
        end
    end
end