from _connection import download
from _storage import store_csv
from tqdm import tqdm

source_uri = 'https://e621.net/tag_alias/index.json?approved=true&page=%d'
target_uri = '../data/aliases.csv'
last_ids = []
page = 0

with tqdm(desc='Crawling') as bar:
    while True:
        page += 1
        bar.update(1)
        success, aliases, code = download(source_uri % page)

        if success and aliases:
            aliases = [a for a in aliases if a['id'] not in last_ids]
            last_ids = [alias['id'] for alias in aliases]

            store_csv(aliases, target_uri, append=(page > 1),
                      fields=['id', 'name', 'alias_id'])
        elif success:
            # no more tags, page is empty
            break
        else:
            print('\nFailed to access page %d, code %d' % (page, code))
            continue
