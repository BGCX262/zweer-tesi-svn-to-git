function [recomList] = onLineRecom_lsaCosine_test (userProfile, model,param)
%userProfile = vector with ratings of a single user
%model = model created with createModel function 
%param
%param.postProcessingFunction = handle of post-processing function (e.g., business-rules)
    dnorm = model.dnorm;
    itemitem=dnorm'*dnorm;
    normVector=sum(itemitem(find(userProfile),:),1);
    recomList=(userProfile*itemitem)./normVector;
    
    if (nargin>=3)
        if(isfield(param,'postProcessingFunction'))
            recomList=feval(param.postProcessingFunction,recomList,param);
        end
    end
    
end