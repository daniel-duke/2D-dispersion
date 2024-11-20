function [wavevectors,contour_info] = get_IBZ_contour_wavevectors(N_k,a,symmetry_type)
    if length(N_k) > 1
        N_k = N_k(1);
        warning('received N_k as a vector')
    end
    
    switch symmetry_type
        case 'p4mm'
            vertices = [0 0; pi/a 0; pi/a pi/a; 0 0];
            wavevectors = get_contour_from_vertices(vertices,N_k);
            vertex_labels = {'$\Gamma$','$X$','$M$','$\Gamma$'};

        case 'c1m1'
            vertices = [0 0; pi/a 0; pi/a pi/a; 0 0; pi/a -pi/a; pi/a 0];
            wavevectors = get_contour_from_vertices(vertices,N_k);
            vertex_labels = {'$\Gamma$','$X$','$M$','$\Gamma$','$\bar{O}$','$X$'};

        case 'p6mm'
            vertices = [0 0; pi/a*cosd(30)*cosd(30) -pi/a*cosd(30)*sind(30); pi/a 0; 0 0];
            wavevectors = get_contour_from_vertices(vertices,N_k);
            vertex_labels = {'$\Gamma$','$X$','$M$','$\Gamma$'};

        case 'none'
            vertices = [0 0; pi/a 0; pi/a pi/a; 0 0; 0 pi/a; -pi/a pi/a; 0 0];
            wavevectors = get_contour_from_vertices(vertices,N_k);
            vertex_labels = {'$\Gamma$','$X$','$M$','$\Gamma$','$Y$','$O$','$\Gamma$'};

        otherwise
            error('symmetry_type not recognized')
    end
    
    contour_info.N_segment = size(vertices,1)-1;
    contour_info.vertices = vertices;
    contour_info.vertex_labels = vertex_labels;
    contour_info.wavenumber = linspace(0,contour_info.N_segment,size(wavevectors,1))';
end

function wavevectors = get_contour_from_vertices(vertices,N_k)
    wavevectors = [];
    for vertex_idx = 1:size(vertices,1)-1
        wavevectors = [wavevectors(1:(end-1),:); linspaceNDim(vertices(vertex_idx,:),vertices(vertex_idx+1,:),N_k)'];
    end
end