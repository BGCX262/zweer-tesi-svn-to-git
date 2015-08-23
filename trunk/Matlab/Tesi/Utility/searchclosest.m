function [i, cv] = searchclosest(Vector, Value)
%SEARCHCLOSEST searches a value in a sorted vector and finds the index and
%the value of the vector that is equal or closest to the value searched. If
%more than one value is equal, then anyone can be returned (this is a
%property of the binary search). If more than one value is closest, then
%the first occurred is returned (this is a property of linear search).
%First a binary search is used to find the value in the vector. If not
%found, then a range obtained by binary search is searched linearlu to find
%the closest value.
%   [I, CV] = SEARCHCLOSEST(VECTOR, VALUE)
%   has no optional parameter.
%   VECTOR is a vector of numeric values. It should already be sorted.
%   VALUE is the numeric value to be searched in the vector.
%   I is the index of value in the vector.
%   CV is the value that is equal or closest to the value searched in the
%   vector.
%
%This program or any other program(s) supplied with it does not provide any
%warranty direct or implied.
%This program is free to use/share for non-commerical purpose only. 
%Kindly reference the author.
%Thanking you.
%@ Copyright M Khan
%Email: mak2000sw@yahoo.com 
%http://www.geocities.com/mak2000sw/
    
    if(nargin < 2)
        help searchclosest;
        return;
    end
    
    from = 1;
    to = length(Vector);

    % Phase 1: Binary Search
    while from <= to
        mid = round((from + to) / 2);    
        diff = Vector(mid) - Value;
        if diff == 0
            i = mid;
            cv = Value;
            return;
        elseif diff < 0
            from = mid + 1;
        else
            to = mid - 1;			
        end
    end

    % Phase 2: Linear Search
    % Remember Bineary search could not find the value in Vector
    % Therefore from > to. Search range is to:from
    y = Vector(to:from);
    [~, mini] = min(abs(y - Value));
    cv = y(mini);
    % cv: closest value
    % mini: local index of minium (closest) value with respect to y
    % find global index of closest value with respect to Vector
    i = to + mini - 1;
end