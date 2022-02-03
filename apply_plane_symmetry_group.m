function prop = apply_plane_symmetry_group(prop,plane_symmetry_group)
    switch plane_symmetry_group
        case 'c1m1'
            orig_min = min(prop,[],'all');
            orig_range = range(prop,'all');
            prop = 1/2*prop + 1/2*prop';
            new_range = range(prop,'all');
            prop = orig_range/new_range*prop;
            new_min = min(prop,[],'all');
            prop = prop - new_min + orig_min;
        case 'none'
            % do nothing
        otherwise
            error('symmetry_type not recognized')
    end
end