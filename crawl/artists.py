from _connection import download
from _storage import store_csv
from tqdm import tqdm

source_uri = 'https://e621.net/artist/index.json?page=%d&limit=100'
info_target_uri = '../data/artists.info.csv'
urls_target_uri = '../data/artists.urls.csv'
last_ids = []
page = 0

with tqdm(desc='Crawling') as bar:
    while True:
        page += 1
        bar.update(1)
        success, artists, code = download(source_uri % page)

        if success and artists:
            info = [a for a in artists if a['id'] not in last_ids]
            urls = [{'id': a['id'], 'url': u} for a in info for u in a['urls']]
            last_ids = [artist['id'] for artist in info]

            store_csv(info, info_target_uri, append=(page > 1), fields=[
                      'id', 'name', 'other_names', 'group_name',
                      'is_active', 'version', 'updater_id'])
            store_csv(urls, urls_target_uri, append=(page > 1), fields=[
                      'id', 'url'])
        elif success:
            # page is empty, we are past the end, this means done
            break
        else:
            print('\nFailed to access page %d, code %d' % (page, code))
            continue
