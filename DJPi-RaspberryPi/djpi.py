#!/usr/bin/env python
# -*- coding: utf8 -*-

import cmd
import logging
import os
import sys
import threading
import time
import urllib2
import urllib
from urllib2 import URLError
import json

from spotify import Link, SpotifyError
from spotify.audiosink import import_audio_sink
from spotify.manager import (SpotifySessionManager, SpotifyPlaylistManager,
    SpotifyContainerManager)

AudioSink = import_audio_sink()

class QueueManager(threading.Thread):
	
	def __init__(self,player, username):
		threading.Thread.__init__(self)
		self.username = "christopher.vanderschuere@gmail.com" #Hack for now
		self.player = player
		self.trackQueue = []	
		self.name = "Theater Room"	

	def run(self):
		print('starting to run')
		self.updateQueue()
	
	def updateQueue(self):
		print "updating Queue"
		quotedQuery = urllib.quote(self.name)
		url = 'http://cdv-djpi.appspot.com/rest/player/tracks?playerTitle=%s' % (quotedQuery)
	#	try:
		req = urllib2.Request(url)
		req.add_header("Content-Type","application/json")
		req.add_header("username",self.username);
		r = urllib2.urlopen(req)
		urls = json.load(r)

		#Load all new urls
		self.trackQueue = urls['tracks'];

		if not self.player.playing and not self.player.loading:
			self.player.next()
	
			
		threading.Timer(10,self.updateQueue).start()	
	#	except URLError as e:
	#		print e.reason + str(e.code)


#Run the manager on a seperate thread
class SpotifyManager(SpotifySessionManager):

	queued = True
	playlist = 2
	track = 0	
	appkey_file = os.path.join(os.path.dirname(__file__), 'spotify_appkey.key')

	def __init__(self,username, *a, **kw):
		SpotifySessionManager.__init__(self, username,*a, **kw)
		self.audio = AudioSink(backend=self)
		self.playing = False
		self._queue = []
		self.currentIndex = 0
		self.track_playing = None
		self.manager = QueueManager(self,username)
		self.loading = False			

	def logged_in(self, session, error):
		if error:
			print(error)
			return
		print("Logged in!")
		self.manager.start()
		

	def logged_out(self, session):
		print("Logged out!")
	
	def load_track(self, track):
		print(u"Loading track...")
		self.loading = True
		while not track.is_loaded():
			time.sleep(1)
		
		if track.is_autolinked(): # if linked, load the target track instead
			print("Autolinked track, loading the linked-to track")
			return self.load_track(track.playable())
		
		if track.availability() != 1:
   			print("Track not available (%s)" % track.availability())
		
		if self.playing:
   			self.stop()
		self.new_track_playing(track)
		self.session.load(track)
		print("Loaded track: %s" % track.name())
		self.play()	
		self.loading = False
		
	def new_track_playing(self, track):
		self.track_playing = track
	
	def play(self):
	   self.audio.start()
	   self.session.play(1)
	   print("Playing")
	   self.playing = True
	
	def stop(self):
	   self.session.play(0)
	   print("Stopping")
	   self.playing = False
	   self.audio.stop()
	
	def music_delivery_safe(self, *args, **kwargs):
	   return self.audio.music_delivery(*args, **kwargs)
	
	def next(self):
		if self.playing:
			self.stop()
		if self.manager.trackQueue:
			if len(self.manager.trackQueue) > self.currentIndex:
				l = Link.from_string(self.manager.trackQueue[self.currentIndex])	
				self.currentIndex += 1
				print self.currentIndex
				if l.type() == Link.LINK_TRACK:
					threading.Timer(0,self.load_track,[l.as_track()]).start()
				else:
					self.stop()
			else:
				print "Reached end of queue"
				self.stop()
	
	def end_of_track(self, sess):
		print("End of track")
		self.audio.end_of_track()
		


if __name__ == '__main__':
	import optparse
	op = optparse.OptionParser(version="%prog 0.1")
	op.add_option("-n", "--playername", help = "Player Name")
	op.add_option("-u", "--username", help="Spotify username")
	op.add_option("-p", "--password", help="Spotify password")
	op.add_option("-v", "--verbose", help="Show debug information",
	dest="verbose", action="store_true")
	(options, args) = op.parse_args()
	if options.verbose:
		logging.basicConfig(level=logging.DEBUG)

	#Register player with GAE at some point


	player = SpotifyManager(options.username,options.password,True);
	player.connect()
