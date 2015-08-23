function [urm] = generateURMfromTimestampFull(urmTimestamp, timestamp, timestampBegin, numRatings)
% function [urm] = generateURMfromTimestampFull(urmTimestamp, timestamp,
% timestampBegin, numRatings)
%
% urmTimestamp = urm nella forma USERrow | ITEMrow | (serial) timestamp
% timestamp = data fino a cui vengono considerati i rating, nella forma
% 'dd/mm/yyyy HH.MM.SS' o nella forma 'dd/mm/yyyy'
% timestampBegin = parametro facoltativo, che indica la data dalla quale vanno
% considerati i rating, nella forma 'dd/mm/yyyy HH.MM.SS' o 'dd/mm/yyyy'
% numRatings = parametro facoltativo, che indica il numero massimo di
% ratings da considerare
    
    if (exist('timestampBegin')==0)
        urm=generateURMfromTimestamp(urmTimestamp, timestamp);
    else
        if (exist('numRatings')==0)
            urm=generateURMfromTimestamp(urmTimestamp, timestamp, timestampBegin);
        else
            urm=generateURMfromTimestamp(urmTimestamp, timestamp, timestampBegin,numRatings);
        end
    end
    urm(max(urmTimestamp(:,1)),max(urmTimestamp(:,2)))=0;
end