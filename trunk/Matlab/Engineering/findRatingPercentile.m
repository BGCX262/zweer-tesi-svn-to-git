function [itemPivot] = findRatingPercentile(urm, percentile)
% function [itemPivot] = findRatingPercentile(urm, percentile)
% trova il percentile per separare items in popolari e non popolari
%
% urm: matrice urm (users x items)
% percentile: [0 1] indicante il percentile da considerare
%
% output: item che separa tra popolari e non popolari, in base al
% percentile scelto
%
% esempio: itemPivot=findRatingPercentile(urm, percentile);

    cumItems=cumsum(sort(full(sum(urm,1)),'descend'));
    itemPivot=searchclosest(cumItems,cumItems(end)*percentile);

end