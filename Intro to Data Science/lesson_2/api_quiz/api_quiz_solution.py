import json
import requests
import pprint

def api_get_request(url):
    # In this exercise, you want to call the last.fm API to get a list of the
    # top artists in Spain.
    #
    # Once you've done this, return the name of the number 1 top artist in Spain.

    data = requests.get(url).text
    data = json.loads(data)

    artist = data['topartists']['artist'][0]
    
    if int(artist['@attr']['rank']) != 1:
        print "Error retrieving the top artist in Spain!"
    
    return artist['name'] # return the top artist in Spain


if __name__ == '__main__':
	# url should be the url to the last.fm api call which
	# will return find the top artists in Spain

    url = u"http://ws.audioscrobbler.com/2.0/?method=geo.gettopartists&country=spain&api_key=3b794a72efb5ce408314975d8954f34d&format=json" 
    print api_get_request(url) 

