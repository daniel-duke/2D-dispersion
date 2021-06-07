function wavevectors = get_IBZ_wavevectors(N_wv,a,symmetry_type,num_tesselations)
    if ~exist('symmetry_type','var')
        symmetry_type = 'none';
    end
    if ~exist('num_tesselations','var')
        num_tesselations = 1;
    end
    if numel(N_wv) == 1
        N_wv = [N_wv N_wv];
    end
    
    if strcmp(symmetry_type,'omit')
        [X,Y] = meshgrid(linspace(-pi/a,pi/a,N_wv(1)),linspace(-pi/a,pi/a,N_wv(2))); % a square centered at the origin of side length 2*pi/a
        k_x = X(true(size(X))); k_y = Y(true(size(Y))); % rect
%         IBZ_shape = 'square';
    elseif strcmp(symmetry_type,'none')
        [X,Y] = meshgrid(linspace(-pi/a,pi/a,N_wv(1)),linspace(0,pi/a,N_wv(2))); % true asymmetric IBZ - note that this IBZ can be rotated arbitrarily!
        k_x = X(true(size(X))); k_y = Y(true(size(Y))); % rect
%         IBZ_shape = 'rectangle';
    elseif strcmp(symmetry_type,'p4mm')
        [X,Y] = meshgrid(linspace(0,pi/a,N_wv(1)),linspace(0,pi/a,N_wv(2))); % these are more points than we need, so we chop it with triu
        k_x = X(triu(true(size(X)))); k_y = Y(triu(true(size(Y)))); % tri
    end
%         IBZ_shape = 'triangle';
    %     [X,Y] = meshgrid(linspace(0,pi/a,N_k),linspace(0,pi/a,N_k));
    %     [X,Y] = meshgrid(linspace(-pi/a,pi/a,N_k),linspace(-pi/a,pi/a,N_k)); % big rect
    %     [X,Y] = meshgrid(3*linspace(-pi/a,pi/a,N_k),3*linspace(-pi/a,pi/a,N_k)); % 3x big rect
    
    %     k_x = X(triu(true(size(X)))); k_y = Y(triu(true(size(Y)))); % tri
%     k_x = X(true(size(X))); k_y = Y(true(size(Y))); % rect

    wavevectors = num_tesselations*cat(2,k_x,k_y);
end