function [ fh ] = fnPlotCsvNetwork(csv, png_out, eps_out)
%fnPlotCsvNetwork load and plots a simple csv saved network in two file types
%   
% INPUT:
%     csv     - the .csv file saved to disk to load and plot
%     png_out - the file name of the .png to save of the loaded network; w/o colorbar
%     eps_out - the file name of the .eps to save of the loaded network; w/ colorbar
%
% OUTPUT:
%     fh      - a figure handle of the plot created
%
%
% Brent McPherson, (c) 2017; Indiana University
%

% load the data
mat = dlmread(csv, ',');

% make the plot
fh = figure;
imagesc(mat)
%caxis([0 1000]); % fix the range
colormap('hot');
axis equal; axis square; axis tight;

% save the png before the colorbar is loaded
saveas(fh, png_out, 'png');

colorbar;

% save the eps after the colorbar is loaded
saveas(fh, eps_out, 'eps');

end

