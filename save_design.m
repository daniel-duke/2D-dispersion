function save_design(modulus,density,poisson,save_file)
    
    % Constitutive data
    modulus = (modulus-ars.myMin(modulus))/(ars.myMax(modulus)-ars.myMin(modulus));
    density = (density-ars.myMin(density))/(ars.myMax(density)-ars.myMin(density));
    poisson = (poisson-ars.myMin(poisson))/(ars.myMax(poisson)-ars.myMin(poisson));
    
    % Plot design
    fig = figure('Visible','off');
    ars.magicPlotLocal(fig);
    plot_design(cat(3,modulus, density, poisson),fig);
    if isSaveFigures == true
        saveas(fig,save_file)
    end

end