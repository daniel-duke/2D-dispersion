function [fig_handle,ax_handle] = plot_dispersion_surface(wv,fr,IBZ_shape,N_k_x,N_k_y,ax)
    
    if ~exist('ax','var')
        fig = figure2();
        ax = axes(fig);
    end
    
    if ~exist('N_k_x','var')
        [~,N_k_size] = size(wv);
        if strcmp(IBZ_shape,'triangle')
            N_k = -1/2 + 1/2*sqrt(1 + 8*N_k_size); % From the quadratic formula ... %tri
        elseif strcmp(IBZ_shape,'rectangle')
            N_k = sqrt(N_k_size); % rect
        end
        N_k_x = N_k;
        N_k_y = N_k;        
    end
    
    Z = nan(N_k_y,N_k_x);
    X = nan(N_k_y,N_k_x);
    Y = nan(N_k_y,N_k_x);
    
    if strcmp(IBZ_shape,'triangle')
        Z(triu(true(N_k))) = squeeze(fr); % tri
        X(triu(true(N_k))) = squeeze(wv(1,:)); % tri
        Y(triu(true(N_k))) = squeeze(wv(2,:)); %tri
    elseif strcmp(IBZ_shape,'rectangle')
        Z = reshape(squeeze(fr),N_k_y,N_k_x); % rect
        X = reshape(squeeze(wv(:,1)),N_k_y,N_k_x); % rect
        Y = reshape(squeeze(wv(:,2)),N_k_y,N_k_x); % rect
    end

    
    surf(ax,X,Y,Z)
    xlabel(ax,'\gamma_x')
    ylabel(ax,'\gamma_y')
    zlabel(ax,'\omega')
    daspect(ax,[pi pi max(max(Z))])
    
    if nargout > 0
        fig_handle = fig;
        ax_handle = ax;
    end
    
end