function [urm] = generateURMfromTimestampCompact(urmTimestamp, timestamp, referencetimestamp)
% function [urm] = generateURMfromTimestampCompact(urmTimestamp, timestamp,
% referencetimestamp)
%
% urmTimestamp = urm nella forma USERrow | ITEMrow | (serial) timestamp
% timestamp = data fino a cui vengono considerati i rating, nella forma
% 'dd/mm/yyyy HH.MM.SS' o nella forma 'dd/mm/yyyy'
% referencetimestamp = data (nella forma 'dd/mm/yyyy HH.MM.SS' o nella 
% forma 'dd/mm/yyyy'), usata come riferimento per considerare gli item
% della matrice URM. Infatti la matrice URM viene generata considerando
% solo gli item esistenti al tempo referencetimestamp
    
    urm = generateURMfromTimestamp(urmTimestamp,timestamp);
    urmRef = generateURMfromTimestamp(urmTimestamp,referencetimestamp);
    
    itemsRef = sum(spones(urmRef),1); %conta i rating di ciascun item
    urm(:,find(itemsRef==0))=0; %azzera items non esistenti al tempo referencetimestamp
    
end