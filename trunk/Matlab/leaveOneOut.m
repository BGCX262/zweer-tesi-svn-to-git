function [positiveTests,negativeTests]=leaveOneOut(algoPath, modelFunction, onLineFunction,urm,urmTrain,positiveTestset,negativeTestset,modelParam,onlineParam)
% function [testedUsers]=leaveOneOut
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
    
    refTime=tic;
    vectorTest(length(testset.i)).rating=-1;
    
    for test = 1:length(testset.i)                  % ciclo su ogni valore del testset
        user = testset.i(test);                     % user = la riga considerata
        item = testset.j(test);                     % item = la colonna considerata
        vettoreActiveUser = urm(user,:);            % vettoreActiveUser = prendo dall'URM la riga del mio user...
        vettoreActiveUser(item) = 0;                % ...e pongo a zero l'item che sto considerando
        viewedItems = find(vettoreActiveUser);      % viewedItems = numero di items rimanenti per quell'utente
        if (length(viewedItems)<2)                      % se ne ho meno di 2
            vectorTest(test).item=item;                 % 
            vectorTest(test).user=user;                 % 
            vectorTest(test).pos=1000;                  % 
            vectorTest(test).rating=-1;                 % 
           continue; 
        end
        %if (exist('onlineParam')==0)
        %    recList = feval(onLineFunction,vettoreActiveUser, model);
        %else
            onlineParam.userToTest=user;                                            % costruisco i parametri per la funzione online
            onlineParam.itemToTest=item;
            onlineParam.viewedItems=viewedItems;
            recList = feval(onLineFunction,vettoreActiveUser, model,onlineParam);   % valuto la funzione online con come parametri il vettoreActiveUser, il modello e i parametri appena costruiti
        %end
        recList(viewedItems) = -inf;                % pongo a -inf i valori che già sapevo
        [rows,cols] = sort(-recList);               % ordino i risultati dell'online in ordine decrescente
        pos = find(cols==item);                     % trovo in che posizione è il valore che devo valutare
        rating = recList(item);                     % trovo quanto gli ho dato di rating
        vectorTest(test).item=item;                 % 
        vectorTest(test).user=user;                 % 
        vectorTest(test).pos=pos;                   % 
        vectorTest(test).rating=rating;             % 
        if (mod(test,100)==0)
            %save tmp vectorTest;
            displayRemainingTime(test, length(testset.i),refTime);
        end
    end
end