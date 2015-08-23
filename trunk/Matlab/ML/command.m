%
% extracting PROBE SET and QUALIFYING SET from URM
%

[i,j]=find(urm);
selected = randsample(length(i),ceil(0.03*length(i))+1);
selectedProbe = selected(1:end/2);
selectedQualifying = selected(end/2+1:end); 
urmQualifying = sparse(i(selectedQualifying),j(selectedQualifying),urm(sub2ind(size(urm),i(selectedQualifying),j(selectedQualifying))));
urmProbe = sparse(i(selectedProbe),j(selectedProbe),urm(sub2ind(size(urm),i(selectedProbe),j(selectedProbe))));