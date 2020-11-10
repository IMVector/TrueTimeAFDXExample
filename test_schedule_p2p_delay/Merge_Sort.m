function [vec] = Merge_Sort(vec)
    n = length(vec);
    if n > 1
        vec = Merge(Merge_Sort(vec(1 : floor(n/2))), Merge_Sort(vec(floor(n/2)+1 : n)));
    end
end

