function [design] = VecToDesign(vec15,N_pix)
% Function to generate 4-fold rotationally symmetric designs 10x10 designs
% from 15-pixels info
% The repeated unit lies in the fourth quadrant, second eighth ccw
%  0  1  2  3  4
%  -  5  6  7  8
%  -  -  9  10 11
%  -  -  -  12 13
%  -  -  -  -  14

% vec15= [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
% unit =...
%   [1  2  3  4  5;
%    0  6  7  8  9;
%    0  0  10  11 12;
%    0  0  0  13 14;
%    0  0  0  0  15];

% %Test code
% clear all; clc; close all; 
% N_pix = 10; 
% vec15 = 1:15; 

m = N_pix/2;
unit = NaN(m,m);
start = 1; 

for rco = 1:m
    len = length(rco:m);  
    unit(rco,rco:end) = vec15(start:start+len-1);  
    start = start+len;
end


unit_mod = triu(unit,1)'; % Extract only the elements above the main diagonal.
ind = find(isnan(unit(:)));
fourth_quad = unit; 
fourth_quad(ind) = unit_mod(ind);
   
lower_half = [flip(fourth_quad, 2) fourth_quad];
design = [flip(lower_half); lower_half];

end




