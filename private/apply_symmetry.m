function A_sym = apply_symmetry(A,symmetry_type)
    N_pix = size(A,1);
    if size(A,2) ~= N_pix
        error('design must be square to apply symmetry')
    end

    A_sym = A;
    switch symmetry_type
        case 'none'
            % do nothing

        case 'c1m1'
            for i = 1:N_pix
                for j = 1:(N_pix-i)
                    A_sym(i,j) = A(N_pix-j+1,N_pix-i+1);
                end
            end

        case 'pmm'
            N_pixH = floor(N_pix/2);
            fieldQ = A( 1:N_pixH, N_pix-N_pixH+1:N_pix );
            A_sym( 1:N_pixH, 1:N_pixH ) = fliplr(fieldQ);
            A_sym( N_pix-N_pixH+1:N_pix, 1:N_pixH ) = rot90(fieldQ,2);
            A_sym( N_pix-N_pixH+1:N_pix, N_pix-N_pixH+1:N_pix ) = flipud(fieldQ);

        case 'p4mm'
            for i = 1:N_pix
                for j = 1:(N_pix-i)
                    A(i,j) = A(N_pix-j+1,N_pix-i+1);
                end
            end
            N_pixH = floor(N_pix/2);
            fieldQ = A( 1:N_pixH, N_pix-N_pixH+1:N_pix );
            A_sym( 1:N_pixH, N_pix-N_pixH+1:N_pix ) = fieldQ;
            A_sym( 1:N_pixH, 1:N_pixH ) = fliplr(fieldQ);
            A_sym( N_pix-N_pixH+1:N_pix, 1:N_pixH ) = rot90(fieldQ,2);
            A_sym( N_pix-N_pixH+1:N_pix, N_pix-N_pixH+1:N_pix ) = flipud(fieldQ);

        otherwise
            error(['symmetry not recognized:' symmetry_type])
    end
end