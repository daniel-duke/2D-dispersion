function [fig_handle,ax_handle] = plot_mode(wv,fr,ev,band_idx,k_idx,plot_type,scale,dispersion_computation,ax)
    unit_cell_length = dispersion_computation.design_variable_interpreter.unit_cell_length;
    n_elements = dispersion_computation.dispersion_computation_parameters.N_element;
    n_pixels = dispersion_computation.dispersion_computation_parameters.N_pixel(1);

    if ~exist('ax','var')
        fig = figure2();
        ax = axes(fig);
    else
        cla(ax);
    end
    
    original_nodal_locations = linspace(0,unit_cell_length,n_elements*n_pixels + 1); %temp*(0:(n_elements*n_pixels))./(n_elements*n_pixels);
    high_resolution_locations = linspace(0,unit_cell_length,100);
    [X,Y] = meshgrid(original_nodal_locations,flip(original_nodal_locations));
    [X_h,Y_h] = meshgrid(high_resolution_locations,flip(high_resolution_locations));
    u_reduced = squeeze(ev(:,k_idx, band_idx));
    %     u_reduced = u_reduced/max(u_reduced)*(1/10)*unit_cell_length;
    T = get_transformation_matrix(wv(k_idx,:),dispersion_computation);
    u = conj(T)*u_reduced;
    u = u/max(abs(u))*(1/10)*unit_cell_length;
    U_vec = u(1:2:end);
    U_mat = reshape(U_vec,n_elements*n_pixels + 1,n_elements*n_pixels + 1)';
    
    U_mat_h = interp2(X,Y,U_mat,X_h,Y_h);
    V_vec = u(2:2:end);
    V_mat = reshape(V_vec,n_elements*n_pixels + 1,n_elements*n_pixels + 1)';
    
    V_mat_h = interp2(X,Y,V_mat,X_h,Y_h);
    
    
    
    if true
        V_plot = V_mat_h;
        U_plot = U_mat_h;
        X_plot = X_h;
        Y_plot = Y_h;
    else
        V_plot = V_mat;
        U_plot = U_mat;
        X_plot = X;
        Y_plot = Y;
    end
    
    
    switch plot_type
        case 'animation'
            plot_animation()
        case 'still'
            plot_still()
    end
    
    if nargout > 0
        fig_handle = ax.Parent;
        ax_handle = ax;
    end
    
    function plot_animation()
        plot(ax,X,Y,'k.');
        axis(ax,[-.2 1.2 -.2 1.2]*unit_cell_length);
        daspect(ax,[1 1 1])
        hold(ax,'on')
        N_cycles = 3.25;
        for t = 1:100
            c = scale*sin(2*pi*t*N_cycles/100);
            p2 = plot(ax,real(X_plot + c*U_plot), real(Y_plot + c*V_plot),'r.');
            pause(.1)
            delete(p2);
        end
        plot(ax,real(X_plot + scale*U_plot), real(Y_plot + scale*V_plot),'r.');
    end
    
    function plot_still()
        contour_scale = 1;
        contourf(ax,real(X_h + scale*U_mat_h),real(Y_h + scale*V_mat_h),sqrt(real(U_mat_h).^2 + real(V_mat_h).^2),100,'LineColor','none');
        colorbar(ax)
        axis(ax,[-.2 1.2 -.2 1.2]*unit_cell_length);
        line(ax,[0 unit_cell_length unit_cell_length 0 0],[0 0 unit_cell_length unit_cell_length 0],'Color','r','LineStyle','--');
        daspect(ax,[1 1 1])
        xlabel(ax,'x + u')
        ylabel(ax,'y + v')
        title(ax,['deformation contour sqrt(u^2 + v^2)' newline 'plotted on deformed shape'])
    end
    
    
end