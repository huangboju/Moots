from bs4 import BeautifulSoup
import os
import requests
from multiprocessing.pool import ThreadPool

def create_dict(dict_name):
    try:
        os.makedirs(dict_name)
    except FileExistsError:
        # directory already exists
        pass

def download(link, file_path):
    albumname = link.get('albumname')
    if albumname == None:
        music_name = link.string
        music_link = link.get('hrefsrc')

        print("downloading: ", music_link)
        response = requests.get(music_link, stream=True)
        if r.status_code == requests.codes.ok:
            with open(fil'./lizhi/' + tmp_albumname + '/' + music_name + '.mp3'e_path, 'wb') as music:
                for chunk in response.iter_content():
                    music.write(chunk)
        else:
            tmp_albumname = albumname
            create_dict('lizhi/' + albumname)


def parser_html():

    create_dict('lizhi')

    with open('lizhi.html', 'rt') as f:
        soup = BeautifulSoup(f, "html.parser")

        tmp_albumname = ""

        links = soup.find_all('a')

        results = ThreadPool(5).imap_unordered(download, links)

        for link in results:


parser_html()