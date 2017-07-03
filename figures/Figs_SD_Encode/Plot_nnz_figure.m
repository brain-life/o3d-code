function [] = Plot_nnz_figure()
load 'nnz_results.mat'

mean_det = mean(nnz_det,2);
mean_prob = mean(nnz_prob,2);

sem_det = std(nnz_det,0,2)/sqrt(size(nnz_det,2));
sem_prob = std(nnz_prob,0,2)/sqrt(size(nnz_det,2));

mean_det_afterlife = mean(nnz_det_afterlife,2);
mean_prob_afterlife = mean(nnz_prob_afterlife,2);

sem_det_afterlife = std(nnz_det_afterlife,0,2)/sqrt(size(nnz_det_afterlife,2));
sem_prob_afterlife = std(nnz_prob_afterlife,0,2)/sqrt(size(nnz_det_afterlife,2));


a = 0.5; % color for error bars
dx = 3; % separation between subjects within a dataset
C = 10; % sem factor amplification
centers = [10, 20, 30]; % x centers for each dataset

figure
plot_nnz(centers, dx, C, a, mean_prob, sem_prob, mean_det, sem_det, [1 2.5 4].*10^7 , [1  4].*10^7)
title('Pre-LiFE')

figure
plot_nnz(centers, dx, C, a, mean_prob_afterlife, sem_prob_afterlife, mean_det_afterlife, sem_det_afterlife, [0 1 2].*10^7, [0 2].*10^7)
title('After-LiFE')


end

function [] = plot_nnz(centers, dx, C, a, mean_prob, sem_prob, mean_det, sem_det, ytick, ylim)
% STN
c = getNiceColors('cold');
hold on;
x0 = centers(1);
x = x0 - 1.5*dx;
ii = 1;
for iSubj = 1:4
    % PROB
    plot(x, mean_prob(iSubj),'o','markerfacecolor',c(ii,:),'markeredgecolor','k','linewidth',0.5,'markersize',14)
    plot([x;x],[mean_prob(iSubj) - C*sem_prob(iSubj)/2; mean_prob(iSubj) + C*sem_prob(iSubj)/2],'-','color',[a a a],'linewidth',2)
    % DET
    plot(x, mean_det(iSubj),'s','markerfacecolor',c(ii,:),'markeredgecolor','k','linewidth',0.5,'markersize',14)
    plot([x;x],[mean_det(iSubj) - C*sem_det(iSubj)/2; mean_det(iSubj) + C*sem_det(iSubj)/2],'-','color',[a a a],'linewidth',2)    
    ii = ii + 1;
    x = x + 0.5*dx;
end

% HCP3T
c = getNiceColors('medium');
hold on;
x0 = centers(2);
x = x0 - 1.5*dx;
ii = 1;
for iSubj = 5:8
    % PROB
    plot(x, mean_prob(iSubj),'o','markerfacecolor',c(ii,:),'markeredgecolor','k','linewidth',0.5,'markersize',14)
    plot([x;x],[mean_prob(iSubj) - C*sem_prob(iSubj)/2; mean_prob(iSubj) + C*sem_prob(iSubj)/2],'-','color',[a a a],'linewidth',2)
    % DET
    plot(x, mean_det(iSubj),'s','markerfacecolor',c(ii,:),'markeredgecolor','k','linewidth',0.5,'markersize',14)
    plot([x;x],[mean_det(iSubj) - C*sem_det(iSubj)/2; mean_det(iSubj) + C*sem_det(iSubj)/2],'-','color',[a a a],'linewidth',2)    
    ii = ii + 1;
    x = x + 0.5*dx;
end

% HCP7T
c = getNiceColors('hot');
hold on;
x0 = centers(3);
x = x0 - 1.5*dx;
ii = 1;
for iSubj = 9:12
    % PROB
    plot(x, mean_prob(iSubj),'o','markerfacecolor',c(ii,:),'markeredgecolor','k','linewidth',0.5,'markersize',14)
    plot([x;x],[mean_prob(iSubj) - C*sem_prob(iSubj)/2; mean_prob(iSubj) + C*sem_prob(iSubj)/2],'-','color',[a a a],'linewidth',2)
    % DET
    plot(x, mean_det(iSubj),'s','markerfacecolor',c(ii,:),'markeredgecolor','k','linewidth',0.5,'markersize',14)
    plot([x;x],[mean_det(iSubj) - C*sem_det(iSubj)/2; mean_det(iSubj) + C*sem_det(iSubj)/2],'-','color',[a a a],'linewidth',2)    
    ii = ii + 1;
    x = x + 0.5*dx;
end

set(gca,'LineStyleOrderIndex',7,'XTick',...
    [5.5 7 8.5 10 15.5 17 18.5 20 25.5 27 28.5 30],'XTickLabel',...
    {'1','2','3','4','5','6','7','8','9','10','11','12'});

set(gca,'tickdir','out', 'ticklen',[0.025 0.025], ...
         'box','off','ytick',ytick, ...
         'ylim', ylim,'xlim', [4 31.5],'fontsize',12)
xlabel('Subject','fontsize',12)
ylabel('Number of non-zero entries','fontsize',12)
end


function c = getNiceColors(color_type)

dotest = false;
c1 = colormap(parula(32));
c2 = colormap(autumn(32));

if dotest
    figure('name','C1 color test');
    hold on
    for ii = 1:size(c1,1)
        plot(ii,1,'o','markerfacecolor',c1(ii,:),'markersize',12)
        text(ii-0.75,1,sprintf('%i',ii))
    end
    
    figure('name','C2 color test');
    hold on
    for ii = 1:size(c2,1)
        plot(ii,1,'o','markerfacecolor',c2(ii,:),'markersize',12)
        text(ii-0.75,1,sprintf('%i',ii))
    end
    keyboard
end

switch color_type
    case 'cold'
        c = [c1([1 3 6 9],:) ];
    case 'medium'
        c = [c1([12 16 19 23],:) ];
    case 'hot'
        c = [c2([32 25 13 5],:)];
        %c = [c2([32 27 19 12 2],:)];
        %c = [c2([32 28 22 18 12 2],:)];
end

end