function [Recall, IntervalBegin, IntervalEnd] = computeConfidenceRecall(Results, N, IndexesFolds)
    
    recall = zeros(1, length(IndexesFolds));
    
    for fold = 1:length(IndexesFolds)
        pos = Results(IndexesFolds(fold).begin:IndexesFolds(fold).end);
        recall(fold) = computeRecall(pos, N);
    end

    recall = recall(find(recall ~= -1));

    Recall = mean(recall);
    stdDev = std(recall);
    IntervalBegin = Recall - 2 * stdDev;
    IntervalEnd = Recall + 2 * stdDev;
end