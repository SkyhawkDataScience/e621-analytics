function allhistory(varargin)

    all = tagged();
    posts = read.data('posts.kpi');

    STEPLO = 1;
    STEPHI = 8;

    [allxlo, allylo] = interpolate(posts.created_at(end:-1:1), STEPLO);
    [allxhi, allyhi] = interpolate(posts.created_at(end:-1:1), STEPHI);


    subplot = @(m,n,p) vendor.subplot(m, n, p, [0.05 0.01], [0.1 0.05], [0.15 0.15]);
    ax1 = subplot(2,1,1);
    ax2 = subplot(2,1,2);

    resultsDiff = zeros(length(allylo) - 1, nargin);
    resultsCsum = zeros(length(allyhi), nargin);

    for iarg = 1:numel(varargin)

        tag = varargin{iarg};
        ids = tagged(tag);
        dates = posts.created_at(ismember(posts.id, ids));

        [~, tagylo] = interpolate(dates(end:-1:1), STEPLO);
        [~, tagyhi] = interpolate(dates(end:-1:1), STEPHI);

        %yy = diff(tagy((1+step):end)) ./ tagy(1:(end-1-step)) * 100;
        resultsDiff(:,iarg) = diff(tagylo ./ allylo) ./ (tagylo(1:end-1) ./ allylo(1:end-1)) * 100;
        resultsCsum(:,iarg) = tagyhi ./ allyhi * 100;

    end

    bars = bar(ax1, allxlo(2:end), diff(allylo) ./ allylo(1:end-1) * 100);
    %l = legend(ax1, plot.label(varargin), 'Location', 'East', 'Interpreter', 'none');
    %l.Position = l.Position + [0.1 0 0 0];
    ylabel(ax1, '% rel. growth');

    lines = plot(ax2, allxhi, allyhi);
    l = legend(ax2, plot.label(varargin), 'Location', 'East', 'Interpreter', 'none');
    l.Position = l.Position + [0.1 0 0 0];
    ylabel(ax2, 'overall %');

    for k = 1:numel(lines)
        bars(k).FaceColor = lines(k).Color;
        bars(k).EdgeAlpha = 0;
        lines(k).LineWidth = 4;
    end

    linkaxes([ax1, ax2], 'x')
    resultsDiff = diff(allylo) ./ allylo(1:end-1) * 100;
    ylim(ax1, [max(-25, min(min(resultsDiff) - 5)), min(105, max(max(resultsDiff)) + 5)])
    xlim(ax1, [2007.9, 2019.9])

    ax1.FontSize = 12;
    ax1.FontWeight = 'bold';
    ax2.FontSize = 12;
    ax2.FontWeight = 'bold';

    ax1.XAxisLocation = 'origin';
    xticks(ax1, []);
    xticks(ax1, 2008:2019);
    xticks(ax2, xticks(ax1));
    xticklabels(ax1, {});
    xticklabels(ax2, strcat('''', arrayfun(@(v) sprintf('%02d', v-2000), xticks(ax2), 'Uniform', false)));

    export.invertcolors();

end


function [xq, yq] = interpolate(dates, step)

    [xx, ii] = unique((double(dates) / 31557600.0) + 1970);
    yy = 1:size(dates, 1);

    xq = (2006:(1/step):2019);
    yq = interp1(xx, yy(ii), xq);

    xq = xq(2:end);
    yq = yq(2:end);

end

