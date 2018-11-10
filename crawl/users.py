from _connection import download
from _storage import store_csv
from datetime import datetime
import sys
from tqdm import tqdm

source_uri = 'https://e621.net/user/index.json?page=%d'
target_uri = '../data/users.csv'

page = int(sys.argv[1])-1 if len(sys.argv) > 1 else 0
last = int(sys.argv[2]) if len(sys.argv) > 2 else float('inf')

with tqdm(desc='Crawling') as bar:
    while True:
        page += 1
        bar.update(1)
        success, users, code = download(source_uri % page)

        if success and users:
            for user in users:
                # flatten user['stats'] into user
                user.update(user['stats'])
                # reformat timestamp
                user['created_at'] = datetime.strptime(
                    user['created_at'], '%Y-%m-%d %H:%M').strftime('%s')

            users = [user for user in users if user['id'] < last]
            last = users[-1]['id'] if users else last

            store_csv(users, target_uri, append=(page > 1), fields=[
                'id', 'name', 'level', 'created_at', 'avatar_id',
                'post_count', 'del_post_count', 'edit_count', 'favorite_count',
                'wiki_count', 'forum_post_count', 'note_count', 'comment_count',
                'blip_count', 'set_count', 'pool_update_count',
                'pos_user_records', 'neutral_user_records', 'neg_user_records'
            ])
        elif success:
            # no more users, page is empty
            break
        else:
            print('\nFailed to access page %d, code %d' % (page, code))
            continue
