function ItemPivot = findRatingPercentile(URM, Percentile)
%FINDRATINGPERCENTILE finds the percentile to separate items in popular and
%unpopular.
%   FINDRATINGPERCENTILE(URM, PERCENTILE)
%   has no optional parameters.
%   URM is the user-item matrix.
%   PERCENTILE [0 1] is the percentile to consider.
%
%   The output is the item to be used as pivot.
    
    if(nargin < 2)
        help findRatingPercentile;
        return;
    end
    
    cumItems = cumsum(sort(full(sum(URM, 1)), 'descend'));
    ItemPivot = searchclosest(cumItems, cumItems(end) * Percentile);
end