# Package

version       = "0.1.0"
author        = "exitcas"
description   = "The software powering the 'Weird Radio Message' Mastodon account and website."
license       = "MIT"
srcDir        = "src"
bin           = @["twrt"]


# Dependencies

requires "nim >= 1.4.8"
requires "docopt >= 0.6.7"
requires "nimpy >= 0.2.0"
requires "regex >= 0.11.1"