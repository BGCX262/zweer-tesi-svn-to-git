function [bu, bi, q, x, y] = learnFactorModelTopK(urm, mu, bu, bi, iterations, lrate, lambda, q, x, y, numberOfItems)
%[bu, bi, q, x, y]
%=
%learnFactorModelTopK
%(urm, mu, bu, bi, iterations, lrate, lambda, q, x, y, numberOfItems)

    warning('learnFactorModelTopK mexFunction not found');

    if(nargout ~= 5 || nargin ~= 11)
        help learnFactorModelTopK;
        return;
    end

    if(size(bu, 2) > size(bu(1)))
        bu = bu';
    end
    if(size(bi, 2) > size(bi(1)))
        bi = bi';
    end

    usersNum = size(urm, 1);
    itemsNum = size(urm, 2);
    ls = size(x, 1);

    urmT = urm';

	for count = 1:iterations
        pseudoRMSE = 0;
        testCount = 0;
        for u = 1:usersNum
            pu = zeros(ls, 1);
            ratedItems = find(urmT(:, u));
            numRatedItems = length(ratedItems);
            
            if(numRatedItems == 0) 
                continue;
            end
            
            for i = 1:numRatedItems
                item = ratedItems(i);
                pu = pu + (urmT(item, u) - (mu + bu(u) + bi(item))) * x(:, item);
                pu = pu + y(:, item);
            end
            
            pu = pu / sqrt(numRatedItems);     
            
            sum = zeros(ls, 1);
            
            for i = 1:numRatedItems
                item = ratedItems(i);
                selectedItems = [item, randsample(setdiff([1:item-1, item+1:itemsNum], ratedItems), numberOfItems)];
                
                r_hat_uis = mu + bu(u) + bi(selectedItems) + q(:, selectedItems)' * pu; 
                
                [rows, ~] = sort(-r_hat_uis);
                rows = -rows;
                
                if(urmT(item, u) >= 3)
                    referenceRating = rows(1);
                else
                    referenceRating = rows(end);
                end
                
                e_ui = referenceRating - r_hat_uis(1);
                pseudoRMSE = pseudoRMSE + e_ui ^ 2;
                testCount = testCount + 1;
                if(abs(e_ui) > 5 || (mod(u, 100) == 0 && i == 1)) 
                    toc;
                    display(['u = ' num2str(u) ', rmse = ' num2str(pseudoRMSE/testCount) ', e_ui = ' num2str(e_ui)]);
                    tic;
                end
                sum = sum + e_ui * q(:, item);
                
                q(:, item) = q(:, item) + lrate * (e_ui * pu - lambda * q(:, item));
                bu(u) = bu(u) + lrate * (e_ui - lambda * bu(u));
                bi(item) = bi(item) + lrate * (e_ui - lambda * bi(item));
            end
            
            for i = 1:numRatedItems
                item = ratedItems(i);
                
                x(:, item) = x(:, item) + lrate * ((urmT(item, u)-(mu + bu(u) + bi(item))) * sum / sqrt(numRatedItems) - lambda * x(:, item));
                y(:, item) = y(:, item) + lrate * (sum / sqrt(numRatedItems) - lambda * y(:, item));
            end
        end
        pseudoRMSE = pseudoRMSE / testCount;
        display(['iteration ' num2str(count) ' - RMSE = ' num2str(pseudoRMSE)]);        
	end
end