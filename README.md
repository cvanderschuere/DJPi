DJPi
====

The goal of this project is to provide a shared music playing device where songs can be choosen from a user quickly and easily.

Usage
=====
DJPi is designed to be easily duplicatable. Following a few steps should allow you to build your own DJPi instance

1.  Deploy DJPi-GAE server code to a Google App Engine instance (You must register and create your own)
2.  Modify base url in project to match your specific app engine url. Example: *XXXXX.appspot.com*
3.  Start DJPi-Pi code on Raspberry Pi with options `python2 djpi.py -u spotify.email@domain.com -p passwordForSpotifyAccount  -n titleOfThisPlayer` to register player
4.  Build and run iOS app to add/remove songs from a player's queue (Don't forget about your appkey.h)
5.  Relax and enjoy the music!

Documentation
=============
##API
Full Documentation of the DJPi API is available at http://docs.djpiapiv1.apiary.io

Building
=========

iOS
---
This project uses two submodules (AFNetworking & CocoaLibSpotify)

* On inital clone use `git clone --recursive https://github.com/cvanderschuere/DJPi.git` to also clone the submodules
* If you do not have the '--recursive' option:
* `git clone https://github.com/cvanderschuere/DJPi.git && cd DJPi && git submodule init && git submodule update`

* If you have already cloned the repo, you can use `git submodule --init` to achieve the same effect


Google App Engine
-----------------
All the source files are provided for creating the necessary server instance. To run in your own project you should create your own app engine account. This will give you a new base URL that will require changes to:

* iOS Source URL
* Pi Source URL
* API Documentation (Optional

Raspberry Pi
------------
Building the player is written with a Raspberry Pi and Arch Linux in mind, but this setup should be fairly easily duplicatable on other hardward running another variant of Linux.

1. Download Arch Linux-arm6hf via torrent file <Link>
2. DD image to SD card (Steps to do this can be found at <Link to easy install raspberry pi webpage>
3. SSH into pi with user:root password:root
3. Install necessary dependencies: 'pacman -S git glibc alsa-lib clang'
4. Copy latest libspotify from http://developer.spotify.com to home directory
5. Run 'make prefix=/usr install'
6. Test pkg export with 'pkg-config --print-provides libspotify' (Should output that library found with correct version number)
8. Clone this repo to /home 'git -r clone https://github.com/cvanderschuere/DJPi.git' 
* If you do not have the '-r' option: `git clone https://github.com/cvanderschuere/DJPi.git && cd DJPi && git submodule init && git submodule update`
9. Init pyspotify library 'python2 setup.py install'
10. Download Spotify app keys from http://developer.spotify.com
 * Raspberry-Pi: Download binary key and place in DJPi-RaspberryPi/ (Should be named spotify_appkey.key)
 * iOS: Copy c code into a file appkey.h and place in DJPi-iOS/ 

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
