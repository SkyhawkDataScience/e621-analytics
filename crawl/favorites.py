from _connection import download
from _storage import read_csv, store_csv
import urllib
import sys
import concurrent.futures
from tqdm import tqdm

source_uri = 'https://e621.net/favorite/list_users.json?id=%s'
fav_file = '../data/posts.favs.csv'
kpi_file = '../data/posts.kpi.csv'
users_file = '../data/users.csv'


def crawl_post(post, total, append=True):
    success, favs, code = download(source_uri % post['id'])

    if success and favs:
        favs = favs['favorited_users'].split(',')
        favs = [{'id': post['id'], 'username': fav} for fav in favs]

        store_csv(favs, fav_file, append, ['id', 'username'])
    else:
        print('post', post['id'], 'failed with code', code)


if __name__ == "__main__":
    def at_least_one_fav(post): return post['fav_count'] != '0'
    posts = read_csv(kpi_file, filter=at_least_one_fav)
    n_posts = len(posts)
    users = {u['name']: u['id'] for u in read_csv(users_file)}

    with concurrent.futures.ThreadPoolExecutor(max_workers=5) as pool:
        # do the first crawl without append to trigger overwrite warning
        crawl_post(posts[0], n_posts, append=False)
        # do the rest in parallel, appending to the file

        fcn = lambda post: crawl_post(post, n_posts, append=True)
        list(tqdm(pool.map(fcn, posts[1:]), total=n_posts-1))
