function [fig_handle,subax_handle] = plot_design(design_variable,design_variable_interpreter)
    dv = design_variable;
    dvi = design_variable_interpreter;
    dv = convert_design_variable(dv,dvi.design_variable_scaling,'linear',dvi);
    
    fig = figure();
    
    N_prop = 3;
    titles = {'Modulus','Density','Poisson'};
    
    prop_name = {'E','rho','nu'};
    for prop_idx = 1:N_prop
        subax(prop_idx) = axes(fig);
        subplot(1,3,prop_idx,subax(prop_idx))
        subplot(subax(prop_idx))
        imagesc(dv.(prop_name{prop_idx}));
        colormap('gray');
        caxis([0 1]);
        daspect([1 1 1]);
        title(titles{prop_idx});
    end
    
    c = colorbar('southoutside');
    c.Position = [.2 .2 .6 .02];
    if nargout > 0
        fig_handle = fig;
        if nargout > 1
            subax_handle = subax;
        end
    end
end