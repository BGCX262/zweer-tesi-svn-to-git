function [positiveTests,negativeTests]=holdOut(algoPath, modelFunction, onLineFunction,urm,urmTrain,positiveTestset,negativeTestset,modelParam,onlineParam)
% function [positiveTests,negativeTests]=holdOut
% (algoPath,urm,urmTrain,positiveTestset,negativeTestset,metricPath,modelParam,onlineParam,metricParam)
% 
% - algoPath = path of algorithm functions
% - modelFunction and onLineFunction = algorithms path,where createModel.m and onLineRecom.m are saved
% - urm = matrix users x items
% - urmTrain = matrix used to train the model. It can correspond to urm
% - positivbeTestset = positive testsets, i.e., the
% indexes of ratings (pairs of user-item) to test. testsetPath must contain
% two test set. They are computed by means of extractTestSets.m function
% and have a struct format. positiveTestset.i and positiveTestset.j are the
% row and column indeces
% - negativeTestset
% - parameters of the algorithm (model and online) and of the metric. The
% format of each parameter is a struct

addpath(algoPath);

%popolarity=full(sum(spones(urm),1));

if (exist('modelParam')==0 || (nargin(modelFunction)<2))
    model = feval(modelFunction,urmTrain);
else
    model = feval(modelFunction,urmTrain,modelParam);
end


%%positiveTests = struct{'item','user','pos','rating'};
%%negativeTests = struct{'item','user','pos','rating'};

% positive instances
if (exist('onlineParam')==0)
    positiveTests = buildVectorTest(positiveTestset,urm,model,onLineFunction);
    negativeTests = buildVectorTest(negativeTestset,urm,model,onLineFunction);
elseif (isstruct(onlineParam))
    positiveTests = buildVectorTest(positiveTestset,urm,model,onLineFunction,onlineParam);
    negativeTests = buildVectorTest(negativeTestset,urm,model,onLineFunction,onlineParam);
else 
    positiveTests = buildVectorTest(positiveTestset,urm,model,onLineFunction);
    negativeTests = buildVectorTest(negativeTestset,urm,model,onLineFunction);    
end

rmpath(algoPath);

end


function [vectorTest] = buildVectorTest(testset,urm,model,onLineFunction,onlineParam)
if isempty(testset.i)
    vectorTest =[];
    return
end
count=0;
for user=1:size(urm,1)
    itemsToTest=testset.j(find(testset.i==user));
    vettoreActiveUser = urm(user,:);
    vettoreActiveUser(itemsToTest) = 0;
    viewedItems = find(vettoreActiveUser);
    if (length(viewedItems)<2 || length(itemsToTest)<1)
       continue; 
    end
    model.userID=user;
    %if (exist('onlineParam')==0)
    %    recList = feval(onLineFunction,vettoreActiveUser, model);
    %else
    onlineParam.testedItems=itemsToTest;
    recList = feval(onLineFunction,vettoreActiveUser, model,onlineParam);
    %end
    recList(viewedItems) = -inf;
    [rows,cols]=sort(-recList);
    for index=1:length(itemsToTest)
        count=count+1;
        item=itemsToTest(index);
        pos = find(cols==item);
        rating = recList(item);
        vectorTest(count).item=item;
        vectorTest(count).user=user;
        vectorTest(count).pos=pos;
        vectorTest(count).rating=rating;
        if (mod(count,500)==0)
            %save tmp vectorTest;
            count
        end
    end
end
end