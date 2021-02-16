function plot_brillouin_square(z)
    line([-pi pi],[-pi -pi],[z z],'color','r')
    line([pi pi],[-pi pi],[z z],'color','r')
    line([pi -pi],[pi pi],[z z],'color','r')
    line([-pi -pi],[pi -pi],[z z],'color','r')
end