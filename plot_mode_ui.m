function plot_mode_ui(dispersion_computation)
    wavevector = dispersion_computation.wavevector;
    frequency = dispersion_computation.frequency;
    eigenvector = dispersion_computation.eigenvector;
    k_idx = 1;
    band_idx = 1;
    scale = .1;
    fig = uifigure('handlevisibility','on');
    ax = uiaxes('Parent', fig, 'Position', [10 10 400 400],'handlevisibility','on');
    plot_mode(wavevector,frequency,eigenvector,band_idx,k_idx,'still',scale,dispersion_computation,ax);
    
    %% GUI definitions
    dropdown_wv = uidropdown(fig,...
        'Position',[430 150 100 22],...
        'Items', array2cell(wavevector'),...
        'ItemsData',1:size(wavevector,1),...
        'ValueChangedFcn', @(dropdown_wv, event) update_plot_wv(dropdown_wv));
    
    dropdown_band =  uidropdown(fig,...
        'Position',[430 110 100 22],...
        'Items', array2cell(1:size(frequency,2)),...
        'ItemsData',1:size(frequency,2),...
        'ValueChangedFcn', @(dropdown_band, event) update_plot_band(dropdown_band));
    
    slider = uislider(fig,...
        'Position',[450 200 150 3],...
        'Orientation','vertical',...
        'Limits',[-.1 .1],...
        'Value',.1,...
        'MajorTicks',linspace(-.1,.1,11),...
        'ValueChangedFcn',@(slider, event) update_scale(slider));
    
    click_button = uibutton(fig,...
        'Position',[430 50 100 22],...
        'Text','Play animation',...
        'ButtonPushedFcn',@(click_button, event) play_animation());
        
    %% Methods for handling user interactions
    function update_plot_wv(dropdown_wv)
        k_idx = dropdown_wv.Value;
        plot_mode(wavevector,frequency,eigenvector,band_idx,k_idx,'still',scale,dispersion_computation,ax);
    end
    
    function update_plot_band(dropdown_band)
        band_idx = dropdown_band.Value;
        plot_mode(wavevector,frequency,eigenvector,band_idx,k_idx,'still',scale,dispersion_computation,ax);
    end
    
    function update_scale(slider)
        scale = slider.Value;
        plot_mode(wavevector,frequency,eigenvector,band_idx,k_idx,'still',scale,dispersion_computation,ax);
    end
    
    function play_animation()
        plot_mode(wavevector,frequency,eigenvector,band_idx,k_idx,'animation',scale,dispersion_computation,ax);
    end
    
    function C = array2cell(A)
        % Each column becomes a character array in the cell
        dbl_cell = num2cell(A',2);
        C = cell(size(dbl_cell));
        for i = 1:length(C)
            C{i} = num2str(dbl_cell{i});
        end
    end
end