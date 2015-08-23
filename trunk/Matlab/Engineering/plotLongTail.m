function [x,y] = plotLongTail (urm,varargin)
%function [x,y] = plotLongTail (urm)

items = sum(urm,1);
[yP,iP]=sort(-items,2);
cumYP = cumsum(-yP);

x=cumYP/max(cumYP);
y=[1:length(cumYP)]/nnz(yP);

plot(x,y,varargin{:});
xlim([0 1]);
ylim([0 1]);
grid on;
xlabel('% of ratings','FontSize',36);
ylabel('% of items','FontSize',36);

end