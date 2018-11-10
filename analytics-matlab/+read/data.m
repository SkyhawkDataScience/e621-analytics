function data = data(setname, varargin)

    persistent cache
    if isempty(cache)
        cache = containers.Map();
    end
    
    try
        data = cache(setname);
    catch
        try
            data = loadfrommatfile(setname);
        catch
            [data, folder] = loadfromcsvfile(setname, varargin{:});
            save([folder filesep setname '.mat'], 'data');
        end
        cache(setname) = data;
    end

end

function data = loadfrommatfile(setname)
    tic()
    fprintf('Loading data from %s.mat ... ', setname);
    data = load([setname '.mat']);
    data = data.data;
    fprintf('done, took %.0fs\n', toc());
end

function [data, folder] = loadfromcsvfile(setname, varargin)
    tic()
    fprintf('\nLoading data from %s.csv.gz ... ', setname);
    data = read.csv([setname '.csv.gz'], varargin{:});
    fprintf('done, took %.0fs\n', toc());
    
    folder = fileparts(which([setname '.csv.gz']));
end

