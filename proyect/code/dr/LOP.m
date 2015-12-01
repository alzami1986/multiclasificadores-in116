function theta = LOP( X, Y )
% P(w_k|s) = \sum_i \theta_{ki} P(w_k|s_i)
% J = \sum_i \sum_k \theta_i \theta_k\sigma_{ik} - \lambda( \sum_i \theta_i - 1 )
% the solution minimizing $J$ is:
% \theta = \Sigma^{-1}I(I^T\Sigma^{-1}I)^{-1}

L = size(X,2);

%Estandarizando
mu = mean(X);
X = bsxfun(@minus, X, mu);
sigma = std(X);
X = bsxfun(@rdivide, X, sigma);

%Error P(w_j|x) - d_{i,j}(x)
X = bsxfun(@minus, Y, X);

%Ecuacion Kuncheva [5.29]
% funcion de costo: J = sum sum w_iw_k Sigma_ik - landa(sum (w_i - 1) )
% min_w J(x)

I = ones(L,1);
Sigma = cov(X);
%Sigma = (1/(size(X12,1)-1))*(X12')*X12;

iSigma = pinv(Sigma);
theta = iSigma*I*pinv(I'*iSigma*I);


end

