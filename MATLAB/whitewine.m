clc;
clear;
close all;

addpath('distributionPlot');
white = readtable('../datasets/winequality-white.csv');

%% miary zbioru

summary(white);

%% rozkład ocen jakości
figure(1);
hist = histogram(white.quality);
title('Rozkład ocen jakości');

binedges = hist.BinEdges + 0.5;
binvals = hist.Values;

text(binedges(1:end-1), binvals, num2str(binvals'), 'vert', 'bottom', ...
    'horiz', 'center');
    
%% rozkład ilości alkoholu
figure(1);
hist = histogram(white.alcohol);
title('Rozkład alkoholu ');

binedges = hist.BinEdges + 0.5;
binvals = hist.Values;

text(binedges(1:end-1), binvals, num2str(binvals'), 'vert', 'bottom', ...
    'horiz', 'center');

%% rozkład ilości siarki
figure(1);
hist = histogram(white.freeSulfurDioxide, 'BinLimits', [0, 100]);
title('Rozkład ilości siarki ');

binedges = hist.BinEdges + 0.5;
binvals = hist.Values;

text(binedges(1:end-1), binvals, num2str(binvals'), 'vert', 'bottom', ...
    'horiz', 'center');

%% rozkład ilości cukru
figure(1);
hist = histogram(white.residualSugar, 'BinLimits', [0, 21]);
title('Rozkład ilości cukru ');

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

%% korelacja między cechami i jakością wina
for i=1:10
   quality_rows = white(white.quality == i, :);
   quality_rows.quality = [];
   if ~isempty(quality_rows)
       figure;
       for column = 1:size(quality_rows, 2)
           subplot(3, 4, column);
           histogram(table2array(quality_rows(:,column)));
           title(quality_rows.Properties.VariableNames(column));
       end
     sgtitle('Wykres dla jakości ' + string(i));
   end
end
