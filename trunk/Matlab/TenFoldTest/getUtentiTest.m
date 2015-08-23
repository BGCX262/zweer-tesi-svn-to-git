function [utentiTest]=getUtentiTest(tabTest,lb,ub)
utentiTest=[];
tabTest2=spones(tabTest(:,1:size(tabTest,2)-1));
tabTest2=sum(tabTest2,2);
utenti=find((tabTest2<=ub) & (tabTest2>=lb));

    for i=1 : length(utenti)
        utentiTest=cat(1,utentiTest,tabTest(utenti(i),:));

    end

end