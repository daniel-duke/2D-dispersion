function [fig_handle,ax_handle] = plot_2Dcomplexdispersion(wv_MG,wv_GX,wv_XM,fr,a)

% if ~exist('ax','var')
%     fig = figure2();
%     ax = axes(fig);
% end

[wv_imag_0,fr_imag_0,wv_imag_pi,fr_imag_pi,wv_real,fr_real,...
    wv_comp,fr_comp] = extract_ReImComplex_WV(wv_MG,wv_GX,wv_XM,fr);

% Filter complex wave vectors
%[wv_comp,fr_comp] = filter_Complex_WV(wv_comp,fr_comp,fr);

% Filter pure real wave vectors
%[wv_real,fr_real] = filter_Real_WV(wv_real,fr_real,fr);

% % Filter pure imaginary wave vectors
% [wv_imag_0,fr_imag_0] = filter_Imag_WV(wv_imag_0,fr_imag_0,fr);
% [wv_imag_pi,fr_imag_pi] = filter_Imag_WV(wv_imag_pi,fr_imag_pi,fr);

% 2D plot
titles = {'M - \Gamma','\Gamma - X','X - M'};
for pco= 1:3
    subplot(1,3,pco)
    scatter(wv_real{pco}/pi,fr_real{pco},4,'k','filled')
    hold on
    scatter((-wv_imag_0{pco})/pi,fr_imag_0{pco},4,'r','filled')
    hold on
    h = scatter((-wv_imag_pi{pco})/pi,fr_imag_pi{pco},4,'r','filled');
    hold on
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    scatter((-imag(wv_comp{pco}))*a/pi,fr_comp{pco},4,'m','filled')
    hold on
    scatter(real(wv_comp{pco})*a/pi,fr_comp{pco},4,'m','filled')
    hold on
    line([0 0],[0 max(fr_real{1})+110],'Color','k','LineWidth',1)
    xlim([-2,1])
    ylim([0 max(fr_real{1})])
    grid on
    xlabel('Wave vector, $\kappa.L/\pi$','interpreter','latex')
    ylabel('Frequency [Hz]')
    title(titles{pco})
    legend('Pure real wavevectors','Pure imaginary wavevectors',...
        'Complex wavevectors','location','southoutside')
    xticks([-1 0.5])
    ax = gca;
    set(ax, 'XTickLabel', {'$-Im(\kappa).L/\pi$', '$Re(\kappa).L/\pi$'},...
        'TickLabelInterpreter', 'latex');
    ax.YMinorGrid = 'on';
    ax.XMinorGrid = 'on';
    hold(ax,'on')

    box on
end

set(gcf,'units','points','position',[50,50,700,400])

if nargout > 0
    fig_handle = gcf;
    ax_handle = gca;
end



end
