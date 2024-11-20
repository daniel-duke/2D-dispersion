function [fig,ax,scatter_handle] = plot_wavevectors(wv,ax)

    if ~exist('ax','var')
        fig = figure();
        ax = axes(fig);
    else
        fig = ax.Parent;
    end

    hold(ax,'on')
    scatter_handle = scatter(ax,wv(:,1),wv(:,2),[],[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerFaceAlpha',.5);
    for i = 1:size(wv,1)
        text(ax,wv(i,1)+.05,wv(i,2)+.05,num2str(i));
    end
    hold(ax,'off')

    xlabel(ax,'$\gamma_x$ [1/m]','Interpreter','latex')
    ylabel(ax,'$\gamma_y$ [1/m]','Interpreter','latex')
    daspect(ax,[1 1 1])
    axis(ax,'padded')
    
    if nargout > 0
        fig = ax.Parent;
    end
end