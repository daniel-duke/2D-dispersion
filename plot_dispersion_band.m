function [fig_handle,ax_handle] = plot_dispersion_band(wavevector,frequency,wavevector_array_size,ax)
    % Needs to be updated for OOP
    % This one uses view(2), where plot_dispersion_surface uses view(3).
    % Seems like these functions should be thought through better.
    if ~exist('ax','var')
        fig = figure();
        ax = axes(fig);
    else
        fig = ax.Parent;
    end
    
    X = reshape(squeeze(wavevector(:,1)),flip(wavevector_array_size)); % rect
    Y = reshape(squeeze(wavevector(:,2)),flip(wavevector_array_size)); % rect
    Z = reshape(frequency,flip(wavevector_array_size)); % rect
    xlims = [min(X,[],'all') max(X,[],'all')];
    ylims = [min(Y,[],'all') max(Y,[],'all')];
    imagesc(ax,xlims,ylims,Z)
    xlabel(ax,'\gamma_x')
    ylabel(ax,'\gamma_y')
    daspect(ax,[pi pi max(max(Z))])
    set(ax,'YDir','normal')
    view(ax,2)
    
    if nargout > 0
        fig_handle = fig;
        ax_handle = ax;
    end
end
