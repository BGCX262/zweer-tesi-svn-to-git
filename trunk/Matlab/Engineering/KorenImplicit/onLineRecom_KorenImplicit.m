function [recomList] = onLineRecom_KorenImplicit (userProfile, model)
%userProfile = vector with ratings of a single user
%model = model created with createModel function 
% model.X = users models
% model.Y = items models
% model.userID = id of the user to be recommended (row in the URM)
%
% NB: userProfile is ignored by this function, model.userID is used
% instead. So be sure to add such field to the model befor calling this
% function.
    
    X=model.X;     
    Y=model.Y;
    userID=model.userID;
    recomList=X(userID,:)*Y';
end