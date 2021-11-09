function [fig_handle,ax_handle] = plot_3Dcomplexdispersion(wv_MG,wv_GX,wv_XM,fr,a,ax)

    if ~exist('ax','var')
        fig = figure2();
        ax = axes(fig);
    end
    
    [wv_imag_0,fr_imag_0,wv_imag_pi,fr_imag_pi,wv_real,fr_real,...
    wv_comp,fr_comp] = extract_ReImComplex_WV(wv_MG,wv_GX,wv_XM,fr);
    
    
    % 3D plot
    for sco = 1:3
        scatter3((sco-1)+wv_real{sco}*a/pi,zeros(1,length(fr_real{sco})),...
            fr_real{sco},'k')
        hold on
        scatter3((sco-1)+zeros(1,length(fr_imag_0{sco})),wv_imag_0{sco}*a/pi,...
            fr_imag_0{sco},'r')
        hold on
        scatter3((sco-1)+zeros(1,length(fr_imag_pi{sco})),wv_imag_pi{sco}*a/pi,...
            fr_imag_pi{sco},'r')
        hold on
        scatter3((sco-1)+zeros(1,length(fr_comp{sco})),imag(wv_comp{sco})*a/pi,...
            fr_comp{sco},'m')
        hold on
        scatter3((sco-1)+real(wv_comp{sco})*a/pi,zeros(1,length(fr_comp{sco})),...
            fr_comp{sco},'g')
        ylim([0,5])
    end
    view([5 -2 5])
    
    
    
    
    
    ax.YMinorGrid = 'on';
    ax.XMinorGrid = 'on';
    ax.ZMinorGrid = 'on';
    hold(ax,'on')
    
    xline(ax,0);
    xline(ax,1);
    xline(ax,2);
    xline(ax,3);
    
    xlabel(ax,'Normalized Wavevector, Re(\kappa).L/\pi')
    ylabel(ax,'Normalized Wavevector, Im(\kappa).L/\pi')
    zlabel(ax,'Frequency (Hz)')
    
    set(ax,'xtick',[0 1 2 3],...
        'xticklabels', {'M', '\Gamma', 'X', 'M'},...
        'fontsize', 15)
    
    if nargout > 0
        fig_handle = ax.Parent;
        ax_handle = ax;
    end
end
