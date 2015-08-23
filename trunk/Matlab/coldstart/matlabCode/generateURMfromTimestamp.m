function [urm] = generateURMfromTimestamp(urmTimestamp, timestamp, timestampBegin,numRatings)
% function [urm] = generateURMfromTimestamp(urmTimestamp, timestamp)
%
% urmTimestamp = urm nella forma USERrow | ITEMrow | (serial) timestamp
% timestamp = data fino a cui vengono considerati i rating, nella forma
% 'dd/mm/yyyy HH.MM.SS' o nella forma 'dd/mm/yyyy'
% timestampBegin = valore facoltativo, che indica la data dalla quale vanno
% considerati i rating, nella forma 'dd/mm/yyyy HH.MM.SS' o 'dd/mm/yyyy'
% numRatings = parametro facoltativo, che indica il numero massimo di
% ratings da considerare
    
    if length(timestamp)<12
        ts = datenum(timestamp,'dd/mm/yyyy')+1;
    else
        ts = datenum(timestamp,'dd/mm/yyyy HH.MM.SS');
    end
    
    if (exist('timestampBegin')==0)
        tsBegin = 0;
    else
        if length(timestampBegin)<12
            tsBegin = datenum(timestampBegin,'dd/mm/yyyy');
        else
            tsBegin = datenum(timestampBegin,'dd/mm/yyyy HH.MM.SS');
        end
    end
    
    indexes = find ((urmTimestamp(:,3)<=ts) & (urmTimestamp(:,3)>tsBegin));
    
    if (exist('numRatings')~=0)
        indexes=indexes(1:numRatings);
    end
    
    urm=sparse(urmTimestamp(indexes,1),urmTimestamp(indexes,2),1);
end