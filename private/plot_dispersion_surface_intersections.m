function [fig,ax,scatter_handle] = plot_dispersion_surface_intersections(wv,fr,N_k_x,N_k_y,ax)
    
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
    
    N_eig = size(fr,2);
    X = reshape(squeeze(wv(:,1)),N_k_y,N_k_x); % rect
    Y = reshape(squeeze(wv(:,2)),N_k_y,N_k_x); % rect
    Z = reshape(fr,N_k_y,N_k_x,N_eig); % rect
    
    hold(ax,'on')
    scatter_handle = gobjects(N_eig-1,1);
    for eig_idx = 2:N_eig
        idxs = find(abs((Z(:,:,eig_idx) - Z(:,:,eig_idx-1))./Z(:,:,eig_idx))<0.5e-2);
        Z_temp = Z(:,:,eig_idx);
        scatter_handle(eig_idx) = scatter3(ax,X(idxs),Y(idxs),Z_temp(idxs),'.');
    end
    hold(ax,'off')
    
    xlabel(ax,'$\gamma_x$ [1/m]','Interpreter','latex')
    ylabel(ax,'$\gamma_y$ [1/m]','Interpreter','latex')
    zlabel(ax,'$\omega$ [Hz]','Interpreter','latex')
    tighten_axes(ax,X,Y)
    daspect(ax,[pi pi max(Z,[],'all')])
    view(ax,[-1,-1,0.5])
end

function tighten_axes(ax,X,Y)
    set(ax,'XLim',[min(min(X)) max(max(X))])
    set(ax,'YLim',[min(min(Y)) max(max(Y))])
end