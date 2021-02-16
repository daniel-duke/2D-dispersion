function out = get_paths_from_M(M)
    end_while = false;
    i = 1;
    N_paths = 0;
    while ~end_while
        N_points = M(2,i);
        i = i + N_points + 1;
        N_paths = N_paths + 1;
        if i > size(M,2)
            end_while = true;
        end
    end
    
    out.paths = cell(N_paths,1);
    out.N_paths = N_paths;
    
    i = 1;
    for j = 1:N_paths
        N_points = M(2,i);
        path_points = M(:,(i+1):(i+N_points));
        i = i + N_points + 1;
        out.paths{j} = path_points;
    end
end