function [model] = createModel_KorenImplicit (URM, modelParam)
% URM = matrix with user-ratings
% modelParam = modelParam.ls specifies the latenSize
%            = modelParam.alpha specifies alpha, i.e. the factor used to
%            compute the confidence of a rating: c_{ui}=1+alpha*r_{ui}
%            = modelParam.lambda specifies the learning rate of each
%            iteration
%            = modelParam.iter specifies the number of iteration,
%            alternating between computing user- item- factors.
%            = modelParam.RatingThreshold specifies a threshold for
%            considering a rating as positive, i.e. ratings higher or equal than
%            threshold are positive, ratings lower than threshold are
%            considered as missing: 
%            p_{ui}=1 if r_{ui}>=threshold, 0 elsewise
%
% Algorithm 'alternate least-square' inspired by 
% "Collaborative Filtering for Implicit Feedback Datasets" 
% Yifan Hu, Yehuda Koren, Chris Volinsky [ICDM 2008]
%

ls=50;
alpha=40;
lambda=150;
iter=20;
RatingThreshold=0;
if (exist('modelParam')~=0)
    if (isstruct(modelParam))
        if (isfield(modelParam,'ls')) 
            ls = modelParam.ls;
        end
        if (isfield(modelParam,'alpha')) 
            alpha = modelParam.alpha;
        end
        if (isfield(modelParam,'lambda')) 
            lambda = modelParam.lambda;
        end        
        if (isfield(modelParam,'iter')) 
            iter = modelParam.iter;
        end           
        if (isfield(modelParam,'RatingThreshold')) 
            iter = modelParam.iter;
        end          
    end
end
    users=size(URM,1);
    items=size(URM,2);  

    Y=rand(items,ls);
    X=zeros(users,ls);
    
    C=alpha*URM; %C=1+alpha*URM; summing 1 has been moved below in function "computeFeatures" for memory optimization!
    P=URM;
    P(find(P<RatingThreshold))=0;
    P=spones(P); 
    
    for iteraz=1:iter
        tic;
        h = waitbar(0,'Please wait...');        
        YY=Y'*Y;
        for u=1:users
            xu=computeFeatures(C,Y,YY,P,u,lambda);
            X(u,:)=xu;
            if (mod(u,1000)==0)            
			disp(['[', num2str(iteraz),'/',num2str(iter),'] ', num2str(u),' (',num2str(u/users*100),'%)   - @ ', num2str(toc/u), 's  - estim = ', num2str(toc*(users-u)/(60*u)),'min']);
                waitbar(u/users,h,['[', num2str(iteraz),'/',num2str(iter),'] ', num2str(u),' (',num2str(u/users*100),'%)   - @ ', num2str(toc/u), 's  - estim = ', num2str(toc*(users-u)/(60*u)),'min']);
            end
        end
        close(h);
        
        h = waitbar(0,'Please wait...');
        XX=X'*X;
        for i=1:items
            yi=computeFeatures(C',X,XX,P',i,lambda);
            Y(i,:)=yi;
            if (mod(i,1000)==0)
			disp(['[', num2str(iteraz),'/',num2str(iter),'] ', num2str(i),' (',num2str(i/items*100),'%)   - @ ', num2str(toc/i), 's  - estim = ', num2str(toc*(items-i)/(60*i)),'min']);
                waitbar(i/items,h,['[', num2str(iteraz),'/',num2str(iter),'] ', num2str(i),' (',num2str(i/items*100),'%)   - @ ', num2str(toc/i), 's  - estim = ', num2str(toc*(items-i)/(60*i)),'min']);
            end
        end        
        close(h);
        disp([num2str(iteraz), ' - ', num2str(toc)]);
    end
    
    model.X=X;     
    model.Y=Y;
end

function [xu] = computeFeatures(C,Y,YY,P,u,lambda)
    items=size(Y,1);
    ls=size(Y,2);
    Cu=diag(1+sparse(C(u,:)));
    pu=full(P(u,:))';
    YCY=full(YY+Y'*(Cu-speye(items))*Y);
    xu=pinv(YCY+lambda*eye(ls))*Y'*Cu*pu;
end