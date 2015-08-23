function [urm] = generateURMfromTimestampCompactUsersItemsFull(urmTimestamp, timestamp, referencetimestamp)
% function [urm] = generateURMfromTimestampCompactUsersItemsFull(urmTimestamp, timestamp,
% referencetimestamp)
%
% urmTimestamp = urm nella forma USERrow | ITEMrow | (serial) timestamp
% timestamp = data fino a cui vengono considerati i rating, nella forma
% 'dd/mm/yyyy HH.MM.SS' o nella forma 'dd/mm/yyyy'
% referencetimestamp = data (nella forma 'dd/mm/yyyy HH.MM.SS' o nella 
% forma 'dd/mm/yyyy'), usata come riferimento per considerare gli utenti
% della matrice URM. Infatti la matrice URM viene generata considerando
% solo gli utenti e gli item esistenti al tempo referencetimestamp
    
    urm = generateURMfromTimestampFull(urmTimestamp,timestamp);
    urmRef = generateURMfromTimestampFull(urmTimestamp,referencetimestamp);
    
    usersRef = sum(spones(urmRef),2); %conta i rating di ciascun user
    urm(find(usersRef==0),:)=0; %azzera users non esistenti al tempo referencetimestamp
    
    itemsRef = sum(spones(urmRef),1); %conta i rating di ciascun item
    urm(:,find(itemsRef==0))=0; %azzera items non esistenti al tempo referencetimestamp
    
end