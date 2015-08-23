function RecomList = onLineRecom(UserProfile, Model, Param)
%ONLINERECOM generates the vector with ratings of a single user with the
%NewNgbr_Koren Algorithm.
%   ONLINERECOM(USERPROFILE, MODEL, PARAM)
%   has no optional parameter.
%   USERPROFILE is the profile of our user. It can be also a row of the urm
%   matrix.
%   MODEL is the one created with createModel function.
%   PARAM.userToTest is the user's row to test (relative to the URM matrix)
%   PARAM.postProcessingFunction handles the post-processing function.
    
    if(nargin < 3)
        help onLineRecom;
        return;
    end
    
    try
        mu = Model.mu;
        bu = Model.bu;
        bi = Model.bi;
        x = Model.x;
        y = Model.y;
        q = Model.q;
        ls = size(x, 1);
        user = Param.userToTest;
    catch e
        display e
        error('Missing some model field');
    end
    
    pu = zeros(ls, 1);
    ratedItems = find(UserProfile);
    numRatedItems = length(ratedItems);
    
    if(numRatedItems == 0) 
       warning('Empty user profile!');
    end
    
    for i = 1:numRatedItems
        item = ratedItems(i);
        pu = pu + (UserProfile(item) - (mu + bu(user) + bi(item))) * x(:, item);
        pu = pu + y(:, item);
    end
    
    pu = pu / sqrt(numRatedItems);   
    
    RecomList = mu + bu(user) + bi + q' * pu; 

    if(isfield(Param, 'postProcessingFunction'))
        RecomList = feval(Param.postProcessingFunction, RecomList, Param);
    end
end