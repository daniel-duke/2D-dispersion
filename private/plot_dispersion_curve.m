function [fig,ax,plot_handle] = plot_dispersion_curve(wn,fr,contour_info,ax)

    if ~exist('ax','var')
        fig = figure();
        ax = axes(fig);
    else
        fig = ax.Parent;
    end
    
    hold(ax,'on')
    plot_handle = plot(ax,wn,fr,'k','LineWidth',1);
    for i = 1:contour_info.N_segment-1
        xline(ax,i);
    end
    hold(ax,'off')
    
    ylabel(ax,'$\omega$ [Hz]','Interpreter','latex')
    xticks(ax,0:contour_info.N_segment)
    xticklabels(ax,contour_info.vertex_labels)
end