clc;
clear;
close all;

white = readtable('../datasets/winequality-red.csv');

%% miary zbioru

summary(white);

%% rozkład ocen jakości
fig1 = figure(1);
fig1.Position(3:4) = [900, 400];

subplot(1,2,1);
hist = histogram(white.quality);
title('Rozkład ocen jakości');

binedges = hist.BinEdges + 0.5;
binvals = hist.Values;

text(binedges(1:end-1), binvals, num2str(binvals'), 'vert', 'bottom', ...
    'horiz', 'center');

subplot(1,2,2);
qint8 = uint8(white.quality);
[Q, QG, QP] = groupcounts(qint8);
pie = pie(Q, '%.2f%%');
legend({'3','4','5','6','7','8','9'});
    
%% rozkład ilości alkoholu
figure(2);
hist = histogram(white.alcohol);
title('Rozkład alkoholu ');

%% rozkład ilości siarki
figure(3);
hist = histogram(white.freeSulfurDioxide, 'BinLimits', [0, 100]);
title('Rozkład ilości siarki ');

%% rozkład ilości cukru
figure(4);
hist = histogram(white.residualSugar, 'BinLimits', [0, 21]);
title('Rozkład ilości cukru ');

%% korelacja między cechami i heatmapy

white_ndarray = table2array(white);
white_size = size(white_ndarray);
white_cols = white.Properties.VariableNames;
% diagonala=1 zaburza skalę kolorów gdy najwyższa korelacja~=0.8
white_corr = corrcoef(white_ndarray) - eye(white_size(2));

figure(5);
heat = heatmap(white_cols, white_cols, white_corr);
title('Współczynniki korelacji między cechami');
heat.Colormap = parula;

%% korelacja między cechami i jakością wina
for i=1:10
   quality_rows = white(white.quality == i, :);
   quality_rows.quality = [];
   if ~isempty(quality_rows)
       figure(7);
       for column = 1:size(quality_rows, 2)
           subplot(3, 4, column);
           histogram(table2array(quality_rows(:,column)));
           title(quality_rows.Properties.VariableNames(column));
       end
     sgtitle('Wykres dla jakości ' + string(i));
   end
end

%% cos tam

fig6 = figure(6);
fig6.Position = [100, 100, 1500, 800];

subplot(2,3,1);
scatter(white.density, white.alcohol,10,white.quality,'filled');
title('% w funkcji gęstości');
colorbar
colormap cool

subplot(2,3,2);
scatter(white.residualSugar, white.density,10,white.quality,'filled');
title('słodkość w funkcji gęstości');
colorbar
colormap cool

subplot(2,3,3);
scatter(white.totalSulfurDioxide, white.density,10,white.quality,'filled');
title('SO2 w funkcji gęstości');
colorbar
colormap cool

subplot(2,3,4);
scatter(white.pH, white.fixedAcidity,10,white.quality,'filled');
title('pH od zawartości kwasów lotnych');
colorbar
colormap cool

subplot(2,3,5);
scatter(white.alcohol, white.residualSugar,10,white.quality,'filled');
title('% w funkcji słodkości');
colorbar
colormap cool

subplot(2,3,6);
scatter(white.alcohol, white.totalSulfurDioxide,10,white.quality,'filled');
title('% od zawartości SO2');
colorbar
colormap cool
