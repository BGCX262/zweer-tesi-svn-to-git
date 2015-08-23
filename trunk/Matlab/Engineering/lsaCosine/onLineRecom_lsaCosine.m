function [recomList] = onLineRecom_lsaCosine (userProfile, model,param)
%userProfile = vector with ratings of a single user
%model = model created with createModel function 
%param
%param.postProcessingFunction = handle of post-processing function (e.g., business-rules)
    dnorm = model.dnorm;
    userProj=normalizeWordsMatrix(userProfile*dnorm',1);
    recomList=userProj*dnorm;
    
    if (nargin>=3)
        if(isfield(param,'postProcessingFunction'))
            recomList=feval(param.postProcessingFunction,recomList,param);
        end
    end
    
end