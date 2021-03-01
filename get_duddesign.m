function [duddesign,domegaddesign] = get_duddesign(Kr,Mr,omega,u,dKrddesign,dMrddesign)
    A = [real(Kr-omega^2*Mr) -imag(Kr-omega^2*Mr) real(-Mr*u) -imag(-Mr*u);
         imag(Kr-omega^2*Mr)  real(Kr-omega^2*Mr) imag(-Mr*u)  real(-Mr*u);
         real(u'*Mr)         -imag(u'*Mr)         0            0          ;
         0 1                      zeros(size([u' u']))                    ];
    
    b = [
        real(-(dKrddesign-omega^2*dMrddesign)*u);
        imag(-(dKrddesign-omega^2*dMrddesign)*u);
        real(1/2*u'*dMrddesign*u);
        0
        ];
    x = A\b;
    duddesign = x(1:2:end-2) + 1i*x(2:2:end-2);
    domegaddesign = x(end-1:end);
end