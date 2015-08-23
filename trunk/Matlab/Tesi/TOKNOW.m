% LeaveOneOut
%   § trovo dove la Probe è uguale a 5.
%   § creo la rispettiva sparsa di 1: testSet.
%   § da testSet estraggo i test Positivi e Negativi.
%   § URMTrain = URM - URMProbe
%   § eseguo il loeaveOneOut
%       # creo il modello partendo dalla URMTrain
%       # per ogni '1' del testSet (prima tutti quelli positivi e poi tutti
%       quelli negativi) valuto la onLine, dopo aver posto quel valore a
%       zero.
%       # trovo che voto ho dato alla coppia e in che posizione è.
%       # alla fine ottengo 2 array. positiveTests e negativeTests, fatto
%       così:
%           .item = la colonna della matrice.
%           .user = la riga della matrice.
%           .pos = la posizione che gli ho dato nel test.
%           .rating = la valutazione che gli ho dato nel test.
%   § faccio computeRMSE tra il positiveTests e URM.
%   § faccio computeRank sul positiveTests.

% HoldOut
%   § estraggo i testSet Positivi e Negativi direttamente (con una funzione
%   diversa da quella vista in leave1out
%   § pasticcio un attimo con URM, creando un URMConfronto e incrementando
%   i valori != 0 di URM di 0.5, mentre quelli di URMConfronto li
%   incremento di 2.5 rispetto ai nuovi di URM, quindi in tutto in
%   URMConfronto sono aumentati di 3
%   § eseguo l'holdOut
%       # creo il modello partendo da URMTrain che ho creato prima in modo
%       bizzarro
%       # per ogni utente dell'urm trovo gli item che devo valutare (quelli
%       con una votazione), pongo a zero queste valutazioni, calcolo
%       l'onLine
%           @ per ogni item presente nell'urm iniziale trovo qunto ha preso
%           di puntegio e che posizione ha, e faccio un array di struct
%           uguale a quello fatto prima
%   § faccio computeRMSE tra il positiveTest e l'URM

% KFolder
%   § estraggo i testSet Positivi e Negativi come ho fatto con HoldOut
%   § eseguo il kfolder
%       # a seconda dei fold divido l'urm in matrice di train e di test.
%       # estraggo i test set, questa volta come nel leave1out
%       # a questo punto faccio il leave1out per calcolare i Tests positivi
%       e negativi...
%   § faccio computeConfidenceRecall tra i test positivi, 5 e gli indici
%   del fold.