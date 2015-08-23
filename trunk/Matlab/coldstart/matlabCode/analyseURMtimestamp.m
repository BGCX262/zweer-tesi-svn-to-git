function [] = analyseURMtimestamp(urmTimestamp)

h= figure;

for i=1:1:239
    urm=generateURMfromTimestamp(urmTimestamp,datestr(addtodate(datenum('02/12/2008','dd/mm/yyyy'),-i,'day'),'dd/mm/yyyy')); 
    urm=compactURM(urm,3);
    [users(i),items(i)]=size(urm);
    ratings(i)=nnz(urm); 
    urmSpones=spones(urm);
    usersLength=sum(urm,2);
    itemsLength=sum(urm,1);    
    userAvgLength(i)=mean(usersLength);    
    itemAvgLength(i)=mean(itemsLength);
    subplot(3,2,1); plot(ratings);
    subplot(3,2,2); plot(ratings./(users.*items));
    subplot(3,2,3); plot(userAvgLength);
    subplot(3,2,5); plot(itemAvgLength);
    subplot(3,2,4); plot(users);
    subplot(3,2,6); plot(items);
    if (mod(i,10)==0) drawnow; 
end
    subplot(3,2,1); title('# ratings'); grid on;
    subplot(3,2,2); title('density'); grid on;
    subplot(3,2,3); title('Avg user views'); grid on;
    subplot(3,2,5); title('Avg item views'); grid on;
    subplot(3,2,4); title('# users'); grid on;
    subplot(3,2,6); title('# items'); grid on;
end