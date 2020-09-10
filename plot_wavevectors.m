function plot_wavevectors(wv)
    figure2();
    hold on
    % axis([-pi/const.a pi/const.a -pi/const.a pi/const.a])
    scatter(wv(1,:),wv(2,:),[],[0 0 0],'MarkerFaceColor',[0 0 0],'MarkerFaceAlpha',.5)
    daspect([1 1 1])
    for i = 1:size(wv,2)
        text(wv(1,i)+.05,wv(2,i)+.05,num2str(i));
    end
    hold off
end