function varargout = orientation( varargin )

    data = struct();
    data.categories = varargin;

    data.genderTags = {'male', 'female', 'intersex', 'ambiguous_gender'};
    data.gender = tagcountmatrix(varargin, data.genderTags);

    data.interactionTags = {'male/male', 'male/female', 'female/female', 'solo'};
    data.interaction = tagcountmatrix(varargin, data.interactionTags);

    if nargout > 0
        fig = figure();
        varargout{1} = fig;
    end

    if nargout > 1
        varargout{1} = data;
    end

    subplot = @(m,n,p) vendor.subplot(m, n, p, [0 0.01], [0.15 0.05], [0.1 0.15]);

    subplot(2,1,1);
    plotbar(data.gender, plot.label(varargin), {'male', 'female', 'intersex', 'ambig.'});
    title('Gender and Interaction');
    xticks([])
    xticklabels({})

    subplot(2,1,2);
    plotbar(data.interaction, plot.label(varargin), {'m/m', 'm/f', 'f/f', 'solo'});

    export.invertcolors();

end

function t = tagcountmatrix(tags, categories)

    t = zeros(numel(tags), numel(categories));

    for itag = 1:numel(tags)
        all = numel(tagged(tags{itag}));
        t(itag, :) = cellfun(@(c) numel(tagged(tags{itag}, c)), categories) / all;
    end

    t = t * 100;

end

function plotbar(values, xlabels, ylabels)

    if size(values, 1) == 1
        tmp = xlabels;
        xlabels = ylabels;
        ylabels = tmp;
    end

    bar(values, 'stacked', 'LineStyle', 'none');
    xticklabels(strrep(xlabels, '_', '\_'));

    if size(values, 1) > 3
        xtickangle(20);
    end

    l = legend(ylabels, 'Location', 'East', ...
        'Orientation', 'vertical', 'Interpreter', 'none');
    l.Position = l.Position + [.14 0 0 0];

    ylim(ylim(gca) * .99);

    a = gca();
    a.FontSize = 10; % pt
    a.FontWeight = 'bold';
    a.LineWidth = 1;
    a.Box = 'off';
    a.Color = 'none';

    ylabel('part in %');

end


