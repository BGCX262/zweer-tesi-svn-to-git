function [model] = createModel_sarwarWithVT (URM,param)
% URM = matrix with user-ratings
    try
        model.vt=param.vt;
        if (isfield(param,'ls'))
            ls = param.ls;
            if (ls<=size(model.vt,1))
                model.vt=model.vt(1:ls,:);
            else
                warning('createModel_sarwarWithVT: specified latent size is not compatible with model');
            end
        end
    catch e
        error ('missing some parameter in createModel_sarwarWithVT');
    end
end