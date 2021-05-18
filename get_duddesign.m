function [duddesign,domegaddesign] = get_duddesign(Kr,Mr,omega,u,dKrddesign,dMrddesign)
    A = full([real(Kr-omega^2*Mr) -imag(Kr-omega^2*Mr) real(-Mr*u) -imag(-Mr*u);
         imag(Kr-omega^2*Mr)  real(Kr-omega^2*Mr) imag(-Mr*u)  real(-Mr*u);
         real(u'*Mr)         -imag(u'*Mr)         0            0          ;
         zeros(1,size(u',2))  1e3 zeros(1,size(u',2)-1) 0       0        ]);
    
    b = full([
        real(-(dKrddesign-omega^2*dMrddesign)*u);
        imag(-(dKrddesign-omega^2*dMrddesign)*u);
        real(-1/2*u'*dMrddesign*u);
        0
        ]);
    
    x = A\b;
%     if rank(A)<size(A,1) %|| rcond(A)<1e-8
%         warning('duddesign system is rank deficient')
%     end
    duddesign = x(1:size(u,1)) + 1i*x(size(u,1)+1:end-2);
    domegaddesign = x(end-1) + 1i*x(end);
end