import csv
import os.path


def read_csv(path, filter=lambda row:True):
    with open(path, 'r') as inputFile:
        reader = csv.DictReader(inputFile)
        return [row for row in reader if filter(row)]


def store_csv(data, path, append=True, fields=None):
    if not append and os.path.isfile(path):
        confirm_overwrite(path)

    with open(path, 'a' if append else 'w') as file:
        writer = csv.DictWriter(file, extrasaction='ignore', fieldnames=fields)
        if not append:
            writer.writeheader()
        writer.writerows(data)


def confirm_overwrite(name):
    print(' ' * 81, end='\r')
    response = input("Overwrite existing file %s? [y/N] " % name)
    if response.lower() not in ['y', 'ye', 'yes']:
        raise Exception('Aborting, will not overwrite file %s' % name)
