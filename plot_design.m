function plot_design(design)
    figure2();
    N_prop = 3;
    titles = {'Modulus','Density','Poisson'};
    
    for prop_idx = 1:N_prop
        subplot(1,3,prop_idx)
        imagesc(squeeze(design(:,:,prop_idx)));
        colormap('gray');
        daspect([1 1 1]);
        title(titles{prop_idx});
    end
    
    c = colorbar('southoutside');
    c.Position = [.2 .2 .6 .02];
    caxis([0 1]);
    
end