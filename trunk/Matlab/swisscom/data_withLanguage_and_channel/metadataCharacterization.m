function [stemCounts,userItems] = metadataCharacterization (urmTS, stems, stemStrings,plotoff)
MINNUMRATINGS=5;

    plotEnabled=true;
    if (exist('plotoff')~=0)
        plotEnabled=false;
    end
    
    if plotEnabled
        h=figure;
    end
    userIdMax=max(urmTS(:,1));
    stemCounts=zeros(userIdMax,length(stemStrings));
    userItems=zeros(userIdMax,1);
    for i=1:userIdMax
        userIndexes = find(urmTS(:,1)==i);
        userItems(i)=length(userIndexes);
        if userItems(i)<1 
            continue
        end
        stemCounts(i,:) = characterizeUser(stems(userIndexes), stemStrings);
        %bar(stemCounts./sum(stemCounts)*100);
        if plotEnabled
            bar(stemCounts(i,:));
            set(gca,'XTickLabel',stemStrings);
            drawnow;
            pause(0.2);
        end
    end

end

function [stemCounts] = characterizeUser(stems, stemStrings)
    stemCounts=zeros(length(stemStrings),1);
    for j=1:length(stemStrings)
        stemString=stemStrings(j);
        stemCounts(j)=sum(strcmp(stemString,stems));        
    end
end