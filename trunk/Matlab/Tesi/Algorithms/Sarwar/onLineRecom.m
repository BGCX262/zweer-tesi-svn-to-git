function RecomList = onLineRecom (UserProfile, Model, Param)
%ONLINERECOM generates the vector with ratings of a single user with the
%Sarwar Algorithm.
%   ONLINERECOM(USERPROFILE, MODEL, PARAM)
%   has one optional parameter.
%   USERPROFILE is the profile of our user. It can be also a row of the urm
%   matrix.
%   MODEL is the one created with createModel function.
%   PARAM.ls is the latent size
%   PARAM.bias is the bias to add to each rating in order to get the
%   predicted rating value. The same is subtracted to the userprofile
%   before getting the recommendations.
%   PARAM.postProcessingFunction handles the post-processing function
    
    if(nargin < 2)
        help onLineRecom;
        return;
    end
    
    vt = Model.vt;
    bias = 0;
    if(nargin>=3)
        if(isfield(Param, 'ls'))
            vt = vt(1:Param.ls, :); 
        end
        
        if(isfield(Param, 'bias'))
            bias = Param.bias;
        end
    end
    
    if(bias ~= 0)
        ratedItems = find(UserProfile);
        UserProfile(ratedItems) = UserProfile(ratedItems) - bias;
    end
    
    RecomList = (UserProfile * (vt') * vt) + bias;
    
    if(nargin >= 3)
        if(isfield(Param, 'postProcessingFunction'))
            RecomList = feval(Param.postProcessingFunction, RecomList, Param);
        end
    end
end