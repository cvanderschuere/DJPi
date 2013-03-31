DJPi
====

The goal of this project is to provide a shared music playing device where songs can be choosen from a user quickly and easily.


Building
================

iOS
---
This project uses two submodules (AFNetworking & CocoaLibSpotify)

* On inital clone use `git clone --recursive <insert url>` to also clone the submodules

* If you have already cloned the repo, you can use `git submodule --init` to achieve the same effect


Google App Engine
-----------------
All the source files are provided for creating the necessary server instance. To run in your own project you should create your own app engine account. This will give you a new base URL that will require changes to:
* API Documentation
* iOS Source URL
* Pi Source URL


Raspberry Pi
------------
