function [ ] = gen_figure_4( )

addpath(genpath('Plotting Utilities'))
folder = '../Data_Storage/Figure_4/';
fnames = dir(folder);

% Load the data generated by the C++ program for this figure
r_arr = get_variable_vals(fnames);
dist_cell = cell(1,length(r_arr));
for r_i = 1:length(r_arr)
    dist = csvread([folder '/data_r_' num2str(r_arr(r_i)) '.csv']);
    dist_cell{r_i} = dist;
end

% Make the figure
close all; figure('units','normalized','position', ...
    [0.6141    0.3813    0.3031    0.4075]);
tight_subplot(1,1,1,[0.12,0.03],[0.10,0.025]); hold on

% Appearance parameters
set(gcf,'color','w')
clrs = brewermap(6,'RdBu');
lw = 1;

violin(dist_cell,               ...
    'edgecolor','none',         ...
    'facecolor',clrs(3,:),      ...
    'facealpha', 1,             ...
    'mc', [],                   ... 
    'medc', [],                 ...
    'bw', 0.02);

hold on;
yl = get(gca,'ylim');
yl(2) = 0.55;
set(gca,'ylim',yl)

% Plot the means
p2 = plot(1:length(r_arr), cellfun(@mean,dist_cell), '.-', 'color', ...
    clrs(2,:), 'linewidth', lw, 'markersize', 18);

% Appearance
ylabel('Peak drive')
xlabel('Initial resistance frequency')

set(gca,'xtick',1:length(r_arr))
set(gca,'xticklabel',strread(num2str(r_arr),'%s'))
set(gca,'ticklength',[0.005,0.005])
set(gca,'tickdir','out')
set(gca,'ytick',0:0.1:0.5)
set(gca,'yticklabel',0:.1:.5)

% Perform the linear regression and plot
mdl = fitlm(r_arr,cellfun(@mean,dist_cell));
r2 = mdl.Rsquared.Ordinary;
text(0.8*length(r_arr),0.75*max(cellfun(@max,dist_cell)),['R^2 = ' sprintf('%1.3f',r2)])
p3 = plot((1:length(r_arr))',mdl.predict(r_arr'),'-s','color',clrs(1,:),'linewidth',lw);
ch = get(gca,'children');
p1 = ch(end);

% Legend
leg = legend([p1,p2,p3],{'Distribution','Mean','Linear regression of mean'});
set(leg,'box','off')

end

function r_arr = get_variable_vals(fnames)

for i = length(fnames):-1:1
    fname = fnames(i).name;
    if fname(1) == '.'
        fnames(i) = [];
    elseif isdir([fnames(i).folder '/' fname])
        fnames(i) = [];
    end
end

r_arr = zeros(1,length(fnames));
for i = 1:length(fnames)
    f = fnames(i).name;
    fs = strsplit(f,{'_'});
    r_arr(i) = str2double(fs{3}(1:end-4));
end

r_arr = unique(r_arr);

end