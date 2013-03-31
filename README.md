DJPi
====

The goal of this project is to provide a shared music playing device where songs can be choosen from a user quickly and easily.

Usage
=====
DJPi is designed to be easily duplicatable. Following a few steps should allow you to build your own DJPi instance

1.  Deploy DJPi-GAE server code to a Google App Engine instance (You must register and create your own)
2.  Modify base url in project to match your specific app engine url. Example: *XXXXX.appspot.com*
3.  Start DJPi-Pi code on Raspberry Pi with options `-u spotify.email@domain.com -t titleOfThisPlayer` to register player
4.  Build and run iOS app to add/remove songs from a player's queue (Don't forget about your appkey.h)
5.  Relax and enjoy the music!

Spotify
=======
Spotify is used as music source and search engine for DJPi.

Setup
-----
In order to build DJPi you need to follow a couple steps:

1. Create, or use an existing, Spotify Premium account that is enabled for development
2. Download the appkey.c (renamed appkey.h in DJPi) from http://developer.spotify.com
3. Include appkey.h to iOS and Raspberry Pi project where appropriate (These two pieces will not compile without one)

Usage
-----

###iOS
* Searching for Artists/Albums/Tracks
* Converting track to URL that can later be played on the Pi

###Raspberry Pi
* Plays spotify URLS


Building
=========

iOS
---
This project uses two submodules (AFNetworking & CocoaLibSpotify)

* On inital clone use `git clone --recursive <insert url>` to also clone the submodules

* If you have already cloned the repo, you can use `git submodule --init` to achieve the same effect


Google App Engine
-----------------
All the source files are provided for creating the necessary server instance. To run in your own project you should create your own app engine account. This will give you a new base URL that will require changes to:

* iOS Source URL
* Pi Source URL
* API Documentation (Optional

Raspberry Pi
------------
