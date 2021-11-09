function [fig_handle,ax_handle] = plot_2Dcomplexdispersion_all(wv_MG,wv_GX,wv_XM,fr,a)

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
for pco= 1:3
    if pco == 1
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
    end
    
    if pco == 2
        scatter(1+wv_real{pco}/pi,fr_real{pco},4,'k','filled')
        hold on
        scatter(1+real(wv_comp{pco})*a/pi,fr_comp{pco},4,'m','filled')
        hold on
    end
    
    if pco == 3
        scatter(3 - wv_real{pco}/pi,fr_real{pco},4,'k','filled')
        hold on
        scatter(3+(wv_imag_0{pco})/pi,fr_imag_0{pco},4,'r','filled')
        hold on
        h = scatter(3+(wv_imag_pi{pco})/pi,fr_imag_pi{pco},4,'r','filled');
        hold on
        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
        scatter(3+(imag(wv_comp{pco}))*a/pi,fr_comp{pco},4,'m','filled')
        hold on
        scatter(3-real(wv_comp{pco})*a/pi,fr_comp{pco},4,'m','filled')
        hold on
        line([3 3],[0 max(fr_real{1})+110],'Color','k','LineWidth',1)
    end
end
xlim([-2,5])
ylim([0 max(fr_real{1})])
grid on
xlabel('Wave vector, Re($\kappa.L/\pi$)','interpreter','latex')
ylabel('Frequency [Hz]')
legend('Pure real wavevectors','Pure imaginary wavevectors',...
    'Complex wavevectors','location','southoutside')
xticks([-1 0 1 2 3 4])
ax = gca;
set(ax, 'XTickLabel', {'-1','M','$\Gamma$','X','M','1'},'TickLabelInterpreter', 'latex');
% Create textbox
set(gcf,'units','points','position',[50,50,700,400])

annotation(gcf,'textbox',...
    [0.820833333333335 0.205366630076839 0.0670593420664469 0.0428100987925357],...
    'String',{'Im($\kappa.L/pi$)'},...
    'LineStyle','none',...
    'Interpreter','latex');

% Create textbox
annotation(gcf,'textbox',...
    [0.153645833333334 0.204268935236005 0.0705315589904785 0.0428100987925357],...
    'String',{'-Im($\kappa.L/pi$)'},...
    'LineStyle','none',...
    'Interpreter','latex');



ax.YMinorGrid = 'on';
ax.XMinorGrid = 'on';
hold(ax,'on')

box on


if nargout > 0
    fig_handle = gcf;
    ax_handle = gca;
end



end
