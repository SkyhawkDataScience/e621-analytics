function out = label(tags)

    out = cell(size(tags));
    
    for itag = 1:numel(tags)
        if iscell(tags{itag})
            parts = regexprep(tags{itag}, '.*?:', '');
            out{itag} = strjoin(parts, ' & ');
        else
            tag = regexprep(tags{itag}, '.*?:', '');
            out{itag} = tag;
        end
    end

end

