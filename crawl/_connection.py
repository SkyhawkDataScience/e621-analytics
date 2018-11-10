import time
import requests
from math import floor

RETRY_SLEEP_TIME = 10  # seconds
HTTP_SUCCESS_CODE = 200


def download(url, retries=5, timeout=10.0):
    """
    This function downloads JSON data from the given URL.
    It retries several times if unsuccessful.

    The output is a tuple (SUCCESS, DATA, STATUS), where SUCCESS is a boolean
    flag, DATA is a dictionary from the decoded JSON or [] if unsuccessful.
    STATUS is the raw http status code.
    """
    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'}
        response = requests.get(url, timeout=timeout, headers=headers)
        success = response.status_code == HTTP_SUCCESS_CODE
        return (success, response.json() if success else [], response.status_code)
    except (requests.exceptions.ReadTimeout, requests.exceptions.ConnectionError) as error:
        if retries > 0:
            print('Retrying', end='\r')
            time.sleep(RETRY_SLEEP_TIME)
            return download(url, retries - 1)
        else:
            return (False, [], -1)
