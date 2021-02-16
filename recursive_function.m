function recursive_function(idxs_left)
    disp(idxs_left)
    idxs_left = idxs_left - 1;
    if idxs_left>0
        recursive_function(idxs_left)
    end
end
