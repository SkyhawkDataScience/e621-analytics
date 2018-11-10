function allIds = tagged(varargin)

    % reading this file multiple times is fast since read.data also caches
    posts_kpi = read.data('posts.kpi', struct( ...
        'id', '%d', ...
        'score', '%d', ...
        'fav_count', '%d', ...
        'rating', '%C', ...
        'created_at', '%d'));
    allIds = posts_kpi.id;

    % if the search was done before, the result comes from the cache instead
    persistent cache
    if isempty(cache)
        cache = containers.Map();
    end

    % allow user to specify either a cell array, strings or multiple arrays
    % it will all be flattened into one big array
    tags = horzcat({}, varargin{:});

    try
        cacheKey = strjoin(tags, ' ');
        allIds = cache(cacheKey);
    catch
        for itag = 1:numel(tags)

            tag = tags{itag};
            negate = tag(1) == '-';
            if negate
                tag = tag(2:end);
            end

            tag = resolvealias(tag);

            if startsWith(tag, 'rating:')
                posts_kpi = read.data('posts.kpi');
                ids = posts_kpi.id(posts_kpi.rating == lower(tag(8)));

            elseif startsWith(tag, 'type:')
                posts_content = read.data('posts.content', struct( ...
                    'id', '%d', 'file_size', '%f', 'file_ext', '%C'));
                ids = posts_content.id(posts_content.file_ext == tag(6:end));

            elseif startsWith(tag, 'artist:')
                posts_artists = read.data('posts.artists');
                ids = posts_artists.id(strcmpi(posts_artists.artist, tag(8:end)));

            elseif startsWith(tag, 'fav:')
                posts_favs = read.data('posts.favs.by_post', struct( ...
                    'id', '%d', 'user_id', '%d'));
                users = read.data('users');
                user_id = users.id(strcmpi(users.name, tag(5:end)));
                ids = posts_favs.id(posts_favs.user_id == user_id);

            elseif startsWith(tag, 'source:')
                posts_content = read.data('posts.content');
                ids = posts_content.id(contains(posts_content.source, tag(8:end)));

            else
                posts_tags = read.data('posts.tags', struct( ...
                    'id', '%d', 'tag', '%C'));
                ids = posts_tags.id(posts_tags.tag == tag);
            end

            if negate
                % exclude the results from the search
                allIds = setdiff(allIds, ids);
            else
                % apply the constraint - create intersection group
                allIds = intersect(allIds, ids);
            end
        end

        cache(cacheKey) = allIds;
    end

end

function tag = resolvealias(tag)

    aliases = read.data('aliases');
    tags = read.data('tags');

    id = aliases.alias_id(strcmp(aliases.name, tag));

    if ~isempty(id)
        tag = tags.name{tags.id == id};
    end

end
