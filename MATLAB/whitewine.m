clc;
clear;
close all;

addpath('distributionPlot');
white = readtable('../datasets/winequality-white.csv');

%% rozkład ocen jakości
figure(1);
hist = histogram(white.quality);
title('Rozkład ocen jakości');

binedges = hist.BinEdges + 0.5;
binvals = hist.Values;

text(binedges(1:end-1), binvals, num2str(binvals'), 'vert', 'bottom', ...
    'horiz', 'center');

%% korelacja między cechami i heatmapy

white_ndarray = table2array(white);
white_size = size(white_ndarray);
white_cols = white.Properties.VariableNames;
% diagonala=1 zaburza skalę kolorów gdy najwyższa korelacja~=0.8
white_corr = corrcoef(white_ndarray) - eye(white_size(2));

figure(2);
heat = heatmap(white_cols, white_cols, white_corr);
title('Współczynniki korelacji między cechami');
heat.Colormap = parula;