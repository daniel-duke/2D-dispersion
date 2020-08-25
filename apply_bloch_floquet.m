function k_ele = apply_bloch_floquet(k_ele,condition,wavevector,const)
    free_var = [];
    switch condition
        case 'rightboundary' % right boundary --> modify local nodes 2 and 3
            %             idxs1 = 3:6; idxs2 = [1:2 7:8]; r = [const.a; 0];
            %             k_ele = modify_k_ele(k_ele,idxs1,idxs2);
            idxs1 = 3:6; idxs2 = 7:8; r = [const.a; 0];
            k_ele = modify_k_ele(k_ele,idxs1,idxs2);
            idxs2 = 1:2; idxs1 = 3:6; r = [const.a; 0];
            k_ele = modify_k_ele(k_ele,idxs1,idxs2);
        case 'bottomboundary' % bottom boundary --> modify local nodes 1 and 2
            idxs1 = 1:4; idxs2 = 5:8; r = [0; -const.a];
            k_ele = modify_k_ele(k_ele,idxs1,idxs2);
        case 'bottomrightcorner' % bottom right corner --> modify local nodes 1,2,3
            if true
                % node 1
                idxs1 = 1:2; idxs2 = 7:8; r = [0; -const.a];
                k_ele = modify_k_ele(k_ele,idxs1,idxs2);
                
                % node 2
                idxs1 = 3:4; idxs2 = 7:8; r = [const.a; -const.a];
                k_ele = modify_k_ele(k_ele,idxs1,idxs2);
                
                % node 3
                idxs1 = 5:6; idxs2 = 7:8; r = [const.a; 0];
                k_ele = modify_k_ele(k_ele,idxs1,idxs2);
            else
                k_ele = modify_k_ele_br(k_ele);
            end
    end
    function k_ele = modify_k_ele(k_ele,idxs1,idxs2)
        k_ele(idxs1,idxs2) = k_ele(idxs1,idxs2)*exp(-1i*dot(wavevector,r));
        k_ele(idxs2,idxs1) = k_ele(idxs2,idxs1)*exp(1i*dot(wavevector,r));
    end
    function k_ele = modify_k_ele_br(k_ele)
        idxs11 = 1:2; idxs22 = 7:8; r = [0; -const.a];
        k_ele(idxs11,idxs22) = k_ele(idxs11,idxs22)*cos(dot(wavevector,r));
        k_ele(idxs22,idxs11) = k_ele(idxs22,idxs11)*cos(dot(wavevector,r));
        idxs11 = 3:4; r = [const.a; -const.a];
        k_ele(idxs11,idxs22) = k_ele(idxs11,idxs22)*cos(dot(wavevector,r));
        k_ele(idxs22,idxs11) = k_ele(idxs22,idxs11)*cos(dot(wavevector,r));
        idxs11 = 5:6; r = [const.a; 0];
        k_ele(idxs11,idxs22) = k_ele(idxs11,idxs22)*cos(dot(wavevector,r));
        k_ele(idxs22,idxs11) = k_ele(idxs22,idxs11)*cos(dot(wavevector,r));
    end
end
