function ibz = get_irreducible_brillouin_zone(wavevector_array_size,unit_cell_length,symmetry_type)
    a = unit_cell_length;
    switch symmetry_type
        case 'p4mm'
            %             vertices = [0 0; pi/a 0; pi/a pi/a; 0 0];
            %             wavevectors = get_contour_from_vertices(vertices);
            %             vertex_labels = {'$\Gamma$','$X$','$M$','$\Gamma$'};
        case 'c1m1'
            %             vertices = [0 0; pi/a 0; pi/a pi/a; 0 0; pi/a -pi/a; pi/a 0]; % Gamma X M Gamma \bar{O} X
            %             wavevectors = get_contour_from_vertices(vertices);
            %             vertex_labels = {'$\Gamma$','$X$','$M$','$\Gamma$','$\bar{O}$','$X$'};
        case 'p6mm'
            %             vertices = [0 0; pi/a*cosd(30)*cosd(30) -pi/a*cosd(30)*sind(30); pi/a 0; 0 0];
            %             wavevectors = get_contour_from_vertices(vertices);
            %             vertex_labels = {'$\Gamma$','$X$','$M$','$\Gamma$'};
        case {'p1','none'}
            %             vertices = [0 0; pi/a 0; pi/a pi/a; 0 0; 0 pi/a; -pi/a pi/a; 0 0];
            %             wavevectors = get_contour_from_vertices(vertices);
            %             vertex_labels = {'$\Gamma$','$X$','$M$','$\Gamma$','$Y$','$O$','$\Gamma$'};
            x_grid_vec = linspace(-pi/a,pi/a,wavevector_array_size(1));
            y_grid_vec = linspace(0,pi/a,wavevector_array_size(2));
            [X,Y] = meshgrid(x_grid_vec,y_grid_vec);
            wavevector = [X(:) Y(:)];
        otherwise
            error('symmetry_type not recognized')
    end

    ibz = IrreducibleBrillouinZone;
    ibz.wavevector_array_size = wavevector_array_size;
    ibz.wavevector = wavevector;
    ibz.N_wavevector = size(wavevector,1);
    ibz.unit_cell_length = unit_cell_length;
end

