function [design] = upix2mat(upix)

    n_upix = size(upix,2); %number of unique pixels
    n = floor(sqrt(n_upix*8+1)-1); % side length of a unit cell
    assert((n/2+1)*(n/4)==n_upix, "invalid shape of upix, correct shape is sum([1,2,...,k])");
    
    design = zeros([size(upix,1) n n]);
    s_i = 1; %start index
    for length=n/2:-1:1
        e_i = s_i + length; %end index
        subarr = upix(:,s_i:e_i-1);
        design(:,n-length+1,n-length+1:end) = subarr;
        design(:,n-length+1:end,n-length+1) = subarr;
        design(:,n-length+1,length:-1:1) = subarr;
        design(:,n-length+1:end,length) = subarr;
        design(:,length:-1:1,n-length+1) = subarr;
        design(:,length,n-length+1:end) = subarr;
        design(:,length,length:-1:1) = subarr;
        design(:,length:-1:1,length) = subarr;
        s_i = s_i + length;
    end
   
    design = squeeze(design); % squeeze if single input