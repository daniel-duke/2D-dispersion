function plot_design(design)
    figure2();
    subplot(1,3,1)
    imagesc(squeeze(design(:,:,1)));
    colormap('gray');
    daspect([1 1 1]);
    title('Modulus');
    
    subplot(1,3,2)
    imagesc(squeeze(design(:,:,2)));
    colormap('gray');
    daspect([1 1 1]);
    title('Density')
    
    subplot(1,3,3)
    imagesc(squeeze(design(:,:,3)));
    colormap('gray');
    daspect([1 1 1]);
    title('Poisson')
end