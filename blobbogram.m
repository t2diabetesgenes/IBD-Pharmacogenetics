function blobbogram( filename )
%This function takes a text file and produces a Forest Plot or Blobbogram.
%The input should be a tab separated text file with columns name, OR, L95
%and U95, where name will be used as the tick labels on the axis, OR is the
%point estimate, and L95 and U95 are the 95% confidence intervals.
%The output is stored in a publication-ready png format and an editable
%.fig format.
%
%   Usage: blobbogram('GORD') will take the association
%   analysis in GORD.txt, generate a Forest Plot, and store it
%   in GORD_ForestPlot.png, which should be publication-ready, and
%   GORD_ForestPlot.png for minor readjustments in MATLAB's GUI.

%   Harry Green (2018) Genetics of Complex Traits

%First read in data and store it in a table T
opts = detectImportOptions( strcat(filename,'.txt'),'NumHeaderLines',0);
T = readtable(strcat(filename,'.txt'),opts);

hold on % Lots of plots needed

plot([1,1],[0,height(T)+1],':k') %first plot a vertical line for x=1
ylim([0 height(T)+1]) %this allows for space at top and bottom

for i=1:height(T)
    plot([T.L95(i),T.U95(i)],[i,i],'b','LineWidth',1) %plot 95% CI
    plot(T.OR(i),i,'b.','MarkerSize',20) %plot point estimate
end

box on

set(gca,'TickLabelInterpreter', 'latex'); %LaTeX font used for figure
yticklabels(T.name); %this reads the name column from the input file for the tick labels
yticks(1:height(T));
title(filename,'Interpreter','latex')
set(gca, 'YGrid', 'on', 'XGrid','off') %the YGrid is helpful for matching axis labels with plot objects

xlabel('Odds Ratio','Interpreter','latex') %more LaTeX

%Save the MATLAB fig
figname=[filename,'_ForestPlot.fig'];
savefig(figname);

%Save the png
set(gcf, 'paperunits', 'centimeters', 'paperposition', [0 0 30 15])
print([filename,'_ForestPlot.png'],'-dpng')
