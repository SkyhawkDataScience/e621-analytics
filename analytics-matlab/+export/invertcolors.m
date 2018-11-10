function invertcolors()

    global LARGE

    fig = gcf();
    fig.PaperUnits = 'centimeters';
    fig.PaperPosition = [0 0 15 10];
    fig.InvertHardcopy = 'off';
    fig.Color = [0 0 0];

    ax = findobj('-property', 'GridLineStyle');
    for a = ax'
        a.XColor = [1,1,1];
        a.YColor = [1,1,1];
        a.Color = 'none';
        a.Box = 'off';
        a.LineWidth = 1;

        if ~isempty(a.Legend)
            a.Legend.TextColor = [1 1 1];
            a.Legend.Box = 'off';
        end

        if ~isempty(LARGE) && LARGE
            a.FontSize = 24;
            a.FontWeight = 'bold';
        end
    end

end

