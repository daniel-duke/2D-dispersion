function [fig_handle,ax_handle] = plot_wavevectors(wv,L,N_k,ax)
    if ~exist('ax','var')
        fig = figure2();
        ax = axes(fig);
    end

    hold(ax,'on')
    % axis([-pi/const.a pi/const.a -pi/const.a pi/const.a])
    scatter(ax,wv(:,1)*L,wv(:,2)*L,[],[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerFaceAlpha',.5)
    daspect(ax,[1 1 1])
%     for i = 1:size(wv,1)
%         text(ax,wv(i,1)*L+.05,wv(i,2)*L+.05,num2str(i))
%     end
    
    set(ax,'xtick',[pi], 'ytick', [pi], 'xticklabels', {'\pi'}, ...
        'yticklabels', {'\pi'}, 'fontsize', 15)
    
    text(ax,wv(1,1)*L+.05,wv(1,2)*L+.15,'M', 'fontsize', 13, ...
        'Color', [0.9 0.3 0.3])
    text(ax,wv(N_k,1)*L+.05,wv(N_k,2)*L+.15,...
        '\Gamma', 'fontsize', 13,'Color', [0.9 0.3 0.3])
    text(ax,wv(2*N_k-1,1)*L+.05,wv(2*N_k-1,2)*L+.15,...
        'X', 'fontsize', 13,'Color', [0.9 0.3 0.3])
    
    

    
    

    
    hold(ax,'off')
    
    xlabel('\kappa_x a')
    ylabel('\kappa_y a')
    
    if nargout > 0
        fig_handle = ax.Parent;
        ax_handle = ax;
    end
    
end
