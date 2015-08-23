days = [14:2:88,109:2:175];

testSVD (days ,15,urm,posTestSet,negTestSet,'recallHomoCompactSVD15.mat');

testSVD (days ,25,urm,posTestSet,negTestSet,'recallHomoCompactSVD25.mat');

testSVD (days ,50,urm,posTestSet,negTestSet,'recallHomoCompactSVD50.mat');

testSVD (days ,100,urm,posTestSet,negTestSet,'recallHomoCompactSVD100.mat');