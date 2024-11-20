function [fig,ax,contour_handle] = plot_dispersion_surface_contour(wv,fr,N_k_x,N_k_y,ax)
    
    if ~exist('ax','var')
        fig = figure();
        ax = axes(fig);
    else
        fig = ax.Parent;
    end
    
    if isempty(N_k_x)||isempty(N_k_y)||~exist('N_k_x','var')||~exist('N_k_y','var')
        warning('guessing the wavevector grid dimensions')
        N_k_x = sqrt(size(wv,1));
        N_k_y = sqrt(size(wv,1));
    end

    N_eig = 1;
    X = reshape(squeeze(wv(:,1)),N_k_y,N_k_x); % rect
    Y = reshape(squeeze(wv(:,2)),N_k_y,N_k_x); % rect
    Z = reshape(fr(:,N_eig),N_k_y,N_k_x); % rect
    
    contour_handle = contour(ax,X,Y,Z);
    xlabel(ax,'$\gamma_x$','Interpreter','latex')
    ylabel(ax,'$\gamma_y$','Interpreter','latex')
    zlabel(ax,'$\omega$','Interpreter','latex')
    tighten_axes(ax,X,Y)
    daspect(ax,[pi pi max(Z,[],'all')])
    view(ax,2)
end

function tighten_axes(ax,X,Y)
    set(ax,'XLim',[min(min(X)) max(max(X))])
    set(ax,'YLim',[min(min(Y)) max(max(Y))])
end