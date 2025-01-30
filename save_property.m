function save_property(prop,save_file)
    fig = figure('Visible','off');
    ax = axes(fig);
    imagesc(prop)
    set(ax,'XTick',[])
    set(ax,'YTick',[])
    colormap('gray')
    daspect([1 1 1])
    imwrite(frame2im(getframe(ax)),save_file)
end