function [model] = createModel_lsaCosine (URM,param)
% URM = matrix with user-ratings
% param.ls = latent size
% param.itemModel = matrice projItem=s*v' (non necessariamente normalizzata)

    d=param.itemModel;
    ls=param.ls;
    
    d=d(1:ls,:); 
    dnorm = normalizeWordsMatrix(d,2); % cosine
    model.dnorm = dnorm; 
end