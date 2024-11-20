function [fig,subax,cbar] = plot_design(design,fig)

    if ~exist('fig','var')
        fig = figure();
    end
    subax = axes(fig);
    
    titles = {'Modulus','Density','Poisson'};
    useTiles = false;
    
    if ~useTiles
        for prop_idx = 1:3
            subax(prop_idx) = subplot(1,3,prop_idx);
            imagesc(squeeze(design(:,:,prop_idx)));
            set(subax(prop_idx),'InnerPosition',[(prop_idx-1)*0.3+0.05 0.4 0.3 0.3])
            set(subax(prop_idx),'XTick',[])
            set(subax(prop_idx),'YTick',[])
            daspect([1 1 1]);
            title(titles{prop_idx});
        end
        cbar_height = 0.3;

    else
        t = tiledlayout(1,3); %#ok
        t.Padding = 'compact';
        for prop_idx = 1:3
            subax(prop_idx) = nexttile;
            imagesc(squeeze(design(:,:,prop_idx)));
            set(subax(prop_idx),'XTick',[])
            set(subax(prop_idx),'YTick',[])
            daspect([1 1 1]);
            title(titles{prop_idx});
        end
        cbar_height = 0.2;
    end
    
    clim([0 1]);
    colormap('gray');
    cbar = colorbar('southoutside');
    cbar.Position = [0.15 cbar_height 0.7 0.02];
    cbar.TickLabelInterpreter = subax(1).TickLabelInterpreter;
    cbar.FontSize = subax(1).FontSize;
end