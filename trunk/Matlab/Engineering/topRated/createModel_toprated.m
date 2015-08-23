function [model] = createModel_toprated (URM,modelParam)
% URM = matrix with user-ratings
    URM=spones(URM);
    topList = sum(URM,1);
    model.topList = topList; %first variable of the model 
    %model.secondVariable = xxx;
end