from _connection import download
from _storage import store_csv
from tqdm import tqdm

source_uri = 'https://e621.net/tag/index.json?limit=500&order=name&page=%d'
target_uri = '../data/tags.csv'
last_ids = []
page = 0

with tqdm(desc='Crawling') as bar:
    while True:
        page += 1
        bar.update(1)
        success, tags, code = download(source_uri % page)

        if success and tags:
            tags = [tag for tag in tags if tag['id'] not in last_ids]
            last_ids = [tag['id'] for tag in tags]

            store_csv(tags, target_uri, append=(page > 1),
                      fields=['id', 'name', 'count', 'type'])
        elif success:
            # no more tags, page is empty
            break
        else:
            print('\nFailed to access page %d, code %d' % (page, code))
            continue
