from bs4 import BeautifulSoup
import os
import requests

def create_dict(dict_name):
    try:
        os.makedirs(dict_name)
    except FileExistsError:
        # directory already exists
        pass

def parser_html():

    create_dict('lizhi')

    with open('李志云音乐.htm', 'rt') as f:
        soup = BeautifulSoup(f, "html.parser")

        tmp_albumname = ""

        for link in soup.find_all('a'):
            albumname = link.get('albumname')
            if albumname == None:
                music_name = link.string
                music_link = link.get('hrefsrc')
                print("🍀", music_name)
                print("🔗", music_link)
                # response = requests.get(music_link, stream=True)

                # if response.status_code == requests.codes.ok:
                #     print("🍀：", tmp_albumname)
                #     print(music_name, music_link)
                #     with open('./lizhi/' + tmp_albumname + '/' + music_name + '.mp3', 'wb') as music:
                #         for chunk in response.iter_content():
                #             music.write(chunk)
                # else:
                #     continue
            else:
                print("\n", albumname, ":")
                tmp_albumname = albumname
                create_dict('lizhi/' + albumname)

parser_html()