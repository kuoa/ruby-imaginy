# Imaginy
Imaginy is a simple ruby script that changes your wallpaper daily, fetching it from the `favorites` section of https://wallhaven.cc.

There is no API involved, the page is parsed and a background image is downloaded individually.
A config.data file is generated automatically.

This script works on all linux flavours.

### Dependencies
* `nokogiri`
* `feh`

### Installation
Just schedule the script to run daily or on system startup.