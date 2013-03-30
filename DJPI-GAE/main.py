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
		#Must pass username
		userName = self.request.headers['username']
		if userName == '':
			self.response.set_status(400)
			return #return nothing if no username passed
		
		#Handle Players
		if self.request.path == "/rest/player/":
			self.response.headers['Content-Type'] = "application/json"
			
			playerName = self.request.get('title')
			
			if playerName == '':
				#Return all players
				q = Player.gql('WHERE user = :1',userName)
				results = q.fetch(limit=5)
				
				output = list()
				for player in results:
					output.append(to_dict(player))
				
				self.response.out.write(json.dumps(output))
			else:
				#Return specific players
				q = Player.gql('WHERE user = :1 AND title = :2',userName,playerName)
				results = q.fetch(limit=5)
				
				output = list()
				for player in results:
					output.append(to_dict(player))
				
				self.response.out.write(json.dumps(output))
				
		elif self.request.path == "/rest/player/tracks":
			#Send tracks as appropriate
			self.response.headers['Content-Type'] = "application/json"
			
			#find which player to modify
			playerTitle = self.request.get("playerTitle")
			if playerTitle == "":
				self.response.set_status(400)
				return
			
			q = Player.gql("WHERE user is :1 AND title is :2",userName,playerTitle)
			players = q.fetch(limit=1)
			
			if len(players) == 0:
				self.response.set_status(400)
				return
			
			#Output array of tracks
			self.response.out.write(json.dumps(players[0].tracks))
			
			
	def post(self):
		#Must pass username
		userName = self.request.headers['username']
		if userName == '':
			self.response.set_status(400)
			return #return nothing if no username passed
			
		if self.request.path == "/rest/player/tracks":
			#return tracks as appropriate
			playerName = self.request.get('playerTitle')
			if playerName == '':
				self.response.set_status(400)
				return
			#Look if object already exists or not
			q = Player.gql("WHERE USER IS :1 AND TITLE IS :2",userName,playerName)
			players = q.fetch(limit=1)
			
			if len(players)==0:
				self.response.set_status(400)
				return
				
			trackDict = json.loads(self.request.body)
			
			for x in trackDict["deletedTracks"]:
				players[0].tracks.remove(x)
				
			for x in trackDict["addedTracks"]:
				players[0].tracks.append(x)
				
			self.response.out.write(json.dumps(players[0].tracks))
			
	#Used to create or modify players		
	def put(self):
		#PUT player is used to create or update player
		if self.request.path == "/rest/player":
		
			userName = self.request.headers['username']
			if userName == '':
				self.response.set_status(400)
				return #return nothing if no username passed
				
			self.response.headers['Content-Type'] = "application/json"
			
			#Parse json body
			playerDict = json.loads(self.request.body)
			
			#Look if object already exists or not
			q = Player.gql("WHERE USER IS :1 AND TITLE IS :2",
	                              playerDict["user"],playerDict["title"])
	        players = q.fetch(limit=1)
	        
			if len(players)==0:
				#Create new player with this information
				newPlayer = Player()
				newPlayer.title = playerDict["title"]
				newPlayer.user = playerDict["user"]
				newPlayer.tracks = []
				newPlayer.put()
				self.response.out.write(json.dumps(to_dict(newPlayer)))
				
			else:
				#Update the first existing player found
				currentPlayer = players[0]
				currentPlayer.title = playerDict["title"]
				currentPlayer.user = playerDict["user"]
				
				#Change tracks accordingly
				if self.request.get("replaceTracks") == "YES" or self.request.get("replaceTracks") == "":
					currentPlayer.tracks = playerDict["tracks"]
				
				self.response.out.write(json.dumps(to_dict(currentPlayer)))
			
		
			
application = webapp.WSGIApplication([
	('/rest/.*', RestEngine)
], debug=True)

def main():
	run_wsgi_app(application)

if __name__ == '__main__':
  main()
	

				