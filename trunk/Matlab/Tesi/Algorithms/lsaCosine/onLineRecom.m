function RecomList = onLineRecom(UserProfile, Model, Param)
%ONLINERECOM generates the vector with ratings of a single user with th
%IsaCosine Algorithm.
%   ONLINERECOM(USERPROFILE, MODEL, PARAM)
%   has no optional parameter.
%   USERPROFILE is the profile of our user. It can be also a row of the urm
%   matrix.
%   MODEL is the one created with createModel function.
%   PARAM.Path must be set to include the utility directory.
%   PARAM.postProcessingFunction handles the post-processing function
    
    if(nargin < 3)
        help onLineRecom;
        return;
    end
    
    if(~isfield(Param, 'Path'))
        help onLineRecom;
        return;
    end
    
    Path = [Param.Path filesep 'Utility'];
    addpath(Path);
    
    dnorm = Model.dnorm;
    userProj = normalizeWordsMatrix(UserProfile * dnorm', 1);
    RecomList = userProj * dnorm;
    
    if(isfield(Param, 'postProcessingFunction'))
        RecomList = feval(Param.postProcessingFunction, RecomList, Param);
    end
    
    rmpath(Path);
end