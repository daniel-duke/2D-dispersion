function [fig_handle,ax_handle] = plot_dispersion_surface(wavevector,frequency,wavevector_array_size,ax)
    % Needs to be updated for OOP
    if ~exist('ax','var')
        fig = figure();
        ax = axes(fig);
    else
        fig = ax.Parent;
    end
    
    X = reshape(squeeze(wavevector(:,1)),flip(wavevector_array_size)); % rect
    Y = reshape(squeeze(wavevector(:,2)),flip(wavevector_array_size)); % rect
    Z = reshape(frequency,flip(wavevector_array_size)); % rect
    
    surf(ax,X,Y,Z)
%     contourf(ax,X,Y,Z)
    xlabel(ax,'\gamma_x')
    ylabel(ax,'\gamma_y')
%     zlabel(ax,'\omega')
    tighten_axes(ax,X,Y)
    daspect(ax,[pi pi max(max(Z))])
    view(ax,3)
    
    if nargout > 0
        fig_handle = fig;
        ax_handle = ax;
    end
end

function tighten_axes(ax,X,Y)
    set(ax,'XLim',[min(min(X)) max(max(X))])
    set(ax,'YLim',[min(min(Y)) max(max(Y))])
end