from bs4 import BeautifulSoup
import os
import urllib.request

def create_dict(dict_name):
    try:
        os.makedirs(dict_name)
    except FileExistsError:
        # directory already exists
        pass

def parser_html():

    create_dict('lizhi')

    with open('lizhi.html', 'rt') as f:
        soup = BeautifulSoup(f, "html.parser")

        for link in soup.find_all('a'):
            albumname = link.get('albumname')
            if albumname == None:
                music_name = link.string
                music_link = link.get('hrefsrc')
                print(music_link)
                filedata = urllib.request.urlopen(music_link)
                datatowrite = filedata.read()

                with open('./lizhi' + music_name + '.mp3', 'wb') as music:
                    music.write(datatowrite)
                break
            else:
                create_dict('lizhi/' + albumname)

parser_html()