function xu = computeFeatures(C, Y, YY, P, u, lambda)
    items = size(Y, 1);
    ls = size(Y, 2);
    Cu = diag(1 + sparse(C(u, :)));
    pu = full(P(u, :))';
    YCY = full(YY + Y' * (Cu - speye(items)) * Y);
    xu = pinv(YCY + lambda * eye(ls)) * Y' * Cu * pu;
end