function [fig_handle,ax_handle] = plot_dispersion(wn,fr,N_k, ax)
    if ~exist('ax','var')
        fig = figure2();
        ax = axes(fig);
    end
    
    plot(ax,wn,fr,'k.-');
    ax.YMinorGrid = 'on';
    ax.XMinorGrid = 'on';
    hold(ax,'on')
    
    xline(ax,0);
    xline(ax,1);
    xline(ax,2);
    xline(ax,3);
    
    xlabel(ax,'Wavevector')
    ylabel(ax,'Frequency (Hz)')
    
    set(ax,'xtick',[0 1 2 3],...
        'xticklabels', {'M', '\Gamma', 'X', 'M'},...
        'fontsize', 15)
    
    if nargout > 0
        fig_handle = ax.Parent;
        ax_handle = ax;
    end
end
