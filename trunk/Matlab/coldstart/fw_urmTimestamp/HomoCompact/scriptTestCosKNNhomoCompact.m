days = [14:2:88,109:2:175];

testCosKNN (days,10,urm,posTestSet,negTestSet,'recallHomoCompactKNN10.mat');

testCosKNN (days,50,urm,posTestSet,negTestSet,'recallHomoCompactKNN50.mat');

testCosKNN (days,100,urm,posTestSet,negTestSet,'recallHomoCompactKNN100.mat');

testCosKNN (days,200,urm,posTestSet,negTestSet,'recallHomoCompactKNN200.mat');