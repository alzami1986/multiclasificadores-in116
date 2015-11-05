function b = findSubspace( list, obj )

n = length(list);
m = length(obj);
b = 1;
for i=1:n

    if length(list{i})==m
        b = sum(abs(list{i}-obj));
        if b==0
        return;
        end
    end

end


end

