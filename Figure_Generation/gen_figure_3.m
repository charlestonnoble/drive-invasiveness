function [ ] = gen_figure_3( )

addpath(genpath('Plotting Utilities/'))

folder = '../Data_Storage/Figure_3/';
fnames = dir(folder);

% Names are of the form: MaxFreqDist_N_1000_i_1.csv
[N_arr, i_arr] = get_variable_vals(fnames);
N_arr(N_arr == 100) = [];

dist_cell = cell(length(N_arr),1);
for N_i = 1:length(N_arr)
    temp_cell = cell(length(i_arr),1);
    for i_i = 1:length(i_arr)
        dist = csvread([folder 'data_N_' num2str(N_arr(N_i)) ...
            '_i_' num2str(i_arr(i_i)) '.csv']);
        temp_cell{i_i} = dist;
    end
    dist_cell{N_i} = temp_cell;
end

addpath('..')
close all; figure('units','normalized','position',[0.4813    0.3875    0.3742    0.3913]);
tight_subplot(1,1,1,[0.15,0.05],[0.11,0.03]); hold on

clrs = brewermap(length(N_arr)+1,'Blues');
clrs(1,:) = [];

ymin = inf;
ymax = -inf;
for N_i = 1:length(N_arr)
    violin(dist_cell{N_i}'               , ...
        'edgecolor','none'          ,...
        'facecolor',clrs(N_i,:)  , ...
        'facealpha', 0.6              , ...
        'mc', [], ... %clr(1,:)              , ...
        'medc', [], 'bw', 0.02);
    temp = get(gca,'ylim');
    if temp(1) < ymin
        ymin = temp(1); 
    end
    if temp(2) > ymax
        ymax = temp(2);
    end
end
set(gca,'ylim',[ymin ymax])
set(gca,'tickdir','out')
set(gca,'ticklength',[0.015, 0.025])
set(gca,'yminortick','on')
set(gca,'xtick',i_arr)
xlabel('Initial drive individuals')
ylabel('Maximum drive frequency')

ch = get(gca,'children');
ch = ch(1:length(i_arr):end);
leg_str = {};
for i = 1:length(N_arr)
    leg_str{i} = ['N = ' num2str(N_arr(i))];
end
leg = legend(ch(end:-1:1),leg_str);
set(leg,'location','northwest')
set(leg,'box','on')
set(leg,'edgecolor','none')

end

function [N_arr, i_arr] = get_variable_vals(fnames)

N_arr = zeros(1,length(fnames)-3);
i_arr = zeros(1,length(fnames)-3);
for i = 4:length(fnames)
    f = fnames(i).name;
    fs = strsplit(f,{'_','.'});
    N_arr(i-3) = str2double(fs{3});
    i_arr(i-3) = str2double(fs{5});
end

N_arr = unique(N_arr);
i_arr = unique(i_arr);

end