function p = predictLOP( post, Theta )
%$$ P(w_k|s) = \sum_i \theta_{ki} P(w_k|s_i) $$
p =  sum((Theta').*post,2);

end

