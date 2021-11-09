clear all; clc;
T_SH = readtable('BG_DATA_SH_Table.dat');
T = readtable('BG_DATA_Table.dat');
load('Designs.mat'); 


%% 
figure, 
subplot(2,1,2)
dfbyfc_SH = T_SH.BandGapSize./T_SH.BandGapLocation; 
bin_edge = 0:0.05:1.2; 
n_bins = length(bin_edge)-1;

h_SH = histogram(dfbyfc_SH, 'BinEdges',bin_edge)
counts_SH = h_SH.Values;
sum_counts = sum(counts_SH);
counts_norm_SH = counts_SH/sum_counts; 
h_SH = histogram('BinEdges',bin_edge, 'BinCounts',counts_norm_SH);
title('\Delta f/f_c probability distribution - SH waves')
xlabel('\Delta f/f_c')
ylabel('Probability')
set(gca,'fontsize', 15)
subplot(2,1,1)
dfbyfc = T.BandGapSize./T.BandGapLocation; 
h = histogram(dfbyfc, 'BinEdges',bin_edge)
counts = h.Values;
sum_counts = sum(counts);
counts_norm = counts/sum_counts; 
h = histogram('BinEdges',bin_edge, 'BinCounts',counts_norm);
title('\Delta f/f_c probability distribution - PSV waves')
xlabel('\Delta f/f_c')
ylabel('Probability')
set(gca,'fontsize', 15)






