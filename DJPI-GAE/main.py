import cgi
import datetime
import urllib
import wsgiref.handlers
import json
import logging

from google.appengine.ext import db
from google.appengine.api import users
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app

#Create Data Models
class Player(db.Model):
	title = db.StringProperty()
	user = db.StringProperty()
	tracks = db.StringListProperty()
	
#Useful for rest
SIMPLE_TYPES = (int, long, float, bool, dict, basestring, list)

def to_dict(model):
    output = {}

    for key, prop in model.properties().iteritems():
        value = getattr(model, key)

        if value is None or isinstance(value, SIMPLE_TYPES):
            output[key] = value
        elif isinstance(value, datetime.date):
            # Convert date/datetime to ms-since-epoch ("new Date()").
            ms = time.mktime(value.utctimetuple())
            ms += getattr(value, 'microseconds', 0) / 1000
            output[key] = int(ms)
        elif isinstance(value, db.GeoPt):
            output[key] = {'lat': value.lat, 'lon': value.lon}
        elif isinstance(value, db.Model):
            output[key] = to_dict(value)
        else:
            raise ValueError('cannot encode ' + repr(prop))

    return output
	
class RestEngine(webapp.RequestHandler):
	
	def get(self):
		#Handle Players
		if self.request.path == "/rest/player/":
			self.response.headers['Content-Type'] = "application/json"
			
			userName = self.request.get('userName')
			if userName == '':
				return #return nothing if no username passed
			
			
			playerName = self.request.get('player')
			
			if playerName == '':
				#Return all players
				q = Player.gql('WHERE user = :1',userName)
				results = q.fetch(limit=5)
				
				output = list()
				for player in results:
					output.append(to_dict(player))
				
				self.response.out.write(json.dumps(output))
				return
			else:
				#Return specific players
				q = Player.gql('WHERE user = :1 AND title = :2',userName,playerName)
				results = q.fetch(limit=5)
				
				output = list()
				for player in results:
					output.append(to_dict(player))
				
				self.response.out.write(json.dumps(output))
				return
	#Used to create or modify players		
	def put(self):
		#PUT player is used to create or update player
		if self.request.path == "/rest/player":
			self.response.headers['Content-Type'] = "application/json"
			
			#Parse json body
			playerDict = json.loads(self.request.body)
			
			#Look if object already exists or not
	      players = db.GqlQuery("SELECT * "
	                              "FROM Player "
	                              "WHERE USER IS :1 AND TITLE IS :2",
	                              playerDict["user"],playerDict["title"])
			if len(players)==0:
				#Create new player with this information
				newPlayer = Player()
				newPlayer.title = playerDict["title"]
				newPlayer.user = playerDict["user"]
				newPlayer.tracks = []
				newPlayer.put()
				self.response.out.write(newPlayer)
				
			else:
				#Update the first existing player found
				currentPlayer = players[0]
				currentPlayer.title = playerDict["title"]
				currentPlayer.user = playerDict["user"]
				
				#Change tracks accordingly
				sentTracks = playerDict["tracks"]
				if len(sentTracks)>len(currentPlayer.tracks):
					#Adding new track to the end of queue
					currentPlayer.tracks.append(sentTracks[len(sentTracks)-1])
				elif len(sentTracks)<len(currentPlayer.tracks):
					#Removing track from front of queue
					currentPlayer.tracks = currentPlayer.tracks[1:]	
					
				self.response.out.write(currentPlayer)
						
		
			
application = webapp.WSGIApplication([
	('/rest/.*', RestEngine)
], debug=True)

def main():
	run_wsgi_app(application)

if __name__ == '__main__':
  main()
	

				