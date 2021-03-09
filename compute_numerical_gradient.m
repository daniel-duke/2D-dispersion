function [fr_x,fr_y] = compute_numerical_gradient(wv,fr,N_k_x,N_k_y)
    
    if isempty(N_k_x)||isempty(N_k_y)||~exist('var','N_k_x')||~exist('var','N_k_y')
        N_k_y = sqrt(size(wv,1));
        N_k_x = sqrt(size(wv,1));
    end
    
    X = reshape(squeeze(wv(:,1)),N_k_y,N_k_x); % rect
    Y = reshape(squeeze(wv(:,2)),N_k_y,N_k_x); % rect
    Z = reshape(fr,N_k_y,N_k_x); % rect
    [Z_x,Z_y] = gradient(Z,X(1,2)-X(1,1),Y(2,1)-Y(1,1));
    
    fr_x = reshape(Z_x,[],1);
    fr_y = reshape(Z_y,[],1);
end