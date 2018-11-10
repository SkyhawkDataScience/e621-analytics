from _connection import download
from _storage import store_csv
from tqdm import tqdm

source_uri = 'https://e621.net/post/index.json?limit=320&before_id=%s'
target_uri = {
    'kpi': '../data/posts.kpi.csv',
    'content': '../data/posts.content.csv',
    'info': '../data/posts.info.csv',
    'tags': '../data/posts.tags.csv',
    'artists': '../data/posts.artists.csv'}
last_id = ''

with tqdm(desc='Crawling') as bar:
    while True:
        bar.update(1)
        success, posts, code = download(source_uri % last_id)

        if success and posts:
            for post in posts:
                # do some preprocessing so the output is more useful
                post['created_at'] = post['created_at']['s']
                post['description'] = post['description'].replace('\n', ' ')

            artists = [{'id': post['id'], 'artist': artist}
                       for post in posts for artist in post['artist']]
            tags = [{'id': post['id'], 'tag': tag}
                    for post in posts for tag in post['tags'].split()]

            append = (last_id != '')
            last_id = posts[-1]['id']

            store_csv(posts, target_uri['kpi'], append, fields=[
                'id', 'score', 'fav_count', 'rating', 'created_at'])
            store_csv(posts, target_uri['content'], append, fields=[
                'id', 'file_size', 'file_ext', 'file_url', 'width',
                'height', 'description', 'source'])
            store_csv(posts, target_uri['info'], append, fields=[
                'id', 'creator_id', 'author', 'change', 'status',
                'has_comments', 'has_notes', 'has_children', 'parent_id'])
            store_csv(tags, target_uri['tags'], append, fields=[
                'id', 'tag'])
            store_csv(artists, target_uri['artists'], append, fields=[
                'id', 'artist'])
        elif success:
            # we are at the end, no more result, finished
            break
        else:
            print('\nFailed to access before id %d, code %d' % (last_id, code))
            continue
