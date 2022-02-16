function ibz_contour = get_irreducible_brillouin_zone_contour(N_wavevector_per_segment,unit_cell_length,symmetry_type)
    N_k = N_wavevector_per_segment;
    a = unit_cell_length;
    vertex_labels = {};
    if length(N_k) > 2
        N_k = N_k(1);
        warning('received N_k as a vector')
    end
    switch symmetry_type
        case 'p4mm'
            vertices = [0 0; pi/a 0; pi/a pi/a; 0 0];
            wavevectors = get_contour_from_vertices(vertices);
            vertex_labels = {'$\Gamma$','$X$','$M$','$\Gamma$'};
        case 'c1m1'
            vertices = [0 0; pi/a 0; pi/a pi/a; 0 0; pi/a -pi/a; pi/a 0];
            wavevectors = get_contour_from_vertices(vertices);
            vertex_labels = {'$\Gamma$','$X$','$M$','$\Gamma$','$\bar{O}$','$X$'};
        case 'p6mm'
            vertices = [0 0; pi/a*cosd(30)*cosd(30) -pi/a*cosd(30)*sind(30); pi/a 0; 0 0];
            wavevectors = get_contour_from_vertices(vertices);
            vertex_labels = {'$\Gamma$','$X$','$M$','$\Gamma$'};
        case {'p1','none'}
            vertices = [0 0; pi/a 0; pi/a pi/a; 0 0; 0 pi/a; -pi/a pi/a; 0 0];
            wavevectors = get_contour_from_vertices(vertices);
            vertex_labels = {'$\Gamma$','$X$','$M$','$\Gamma$','$Y$','$O$','$\Gamma$'};
        case 'all contour segments'
            vertices = ...
                [0 0; pi/a 0;
                0 0; pi/a pi/a;
                0 0; 0 pi/a;
                0 0; -pi/a pi/a;
                0 0; -pi/a 0;
                0 0; -pi/a -pi/a;
                0 0; 0 -pi/a;
                0 0; pi/a -pi/a;
                pi/a 0; pi/a pi/a;
                pi/a pi/a; 0 pi/a;
                0 pi/a; -pi/a pi/a;
                -pi/a pi/a; -pi/a 0;
                -pi/a 0; -pi/a -pi/a;
                -pi/a -pi/a; 0 -pi/a;
                0 -pi/a; pi/a -pi/a;
                pi/a -pi/a; pi/a 0];
            wavevectors = [];
            for vertex_idx = 1:2:(size(vertices,1)-1)
                if vertex_idx <= 17
                    wavevectors = [wavevectors; linspaceNDim(vertices(vertex_idx,:),vertices(vertex_idx+1,:),N_k)'];
                else
                    wavevectors = [wavevectors(1:(end-1),:); linspaceNDim(vertices(vertex_idx,:),vertices(vertex_idx+1,:),N_k)'];
                end
            end
        otherwise
            error('symmetry_type not recognized')
    end
    N_segment = size(vertices,1) - 1;
    if isempty(vertex_labels)
        warning('critical_point_labels not yet defined for this symmetry_type')
    end
    
    ibz_contour = IrreducibleBrillouinZoneContour;
    ibz_contour.N_k = N_k;
    ibz_contour.N_segment = N_segment;
    ibz_contour.vertices = vertices;
    ibz_contour.vertex_labels = vertex_labels;
    ibz_contour.wavevector = wavevectors;
    ibz_contour.wavevector_parameter = linspace(0,N_segment,size(wavevectors,1));
    ibz_contour.unit_cell_length = unit_cell_length;
    
    function wavevectors = get_contour_from_vertices(vertices)
        wavevectors = [];
        for vertex_idx = 1:(size(vertices,1)-1)
            wavevectors = [wavevectors(1:(end-1),:); linspaceNDim(vertices(vertex_idx,:),vertices(vertex_idx+1,:),N_k)'];
        end
    end
end

