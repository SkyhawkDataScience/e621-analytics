function data = csv(filename, columns)
    if nargin == 1
        data = readfromgzipped(filename, @readtable);
    else
        data = readfromgzipped(filename, @(f) readwithtextscan(f, columns));
    end
end

function data = readfromgzipped(filename, readerfcn)
    if endsWith(filename, '.gz')
        gunzip(filename, '.');

        filename = strrep(filename, '.gz', '');
        data = readerfcn(filename);
        delete(filename);
    else
        data = readerfcn(filename);
    end
end

function data = readwithtextscan(filename, columns)
    format = [strjoin(struct2cell(columns), ' '), '%*[^\r\n]'];

    fid = fopen(filename, 'r', 'n', 'UTF-8');
    data = textscan(fid, format, 'Delimiter', ',', 'HeaderLines', 1);
    fclose(fid);
    
    data = table(data{:}, 'VariableNames', fieldnames(columns));
end

