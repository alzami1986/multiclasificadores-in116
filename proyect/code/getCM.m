function cm = getCM( y, y_est, num_c )
%getCM Summary of this function goes here
%   Detailed explanation goes here

cm = zeros(num_c);
cla = 1:num_c;

for i=1:num_c
    for j=1:num_c
    cm(i,j) = sum(y == cla(i) & y_est == cla(j));     
    end
end


end


