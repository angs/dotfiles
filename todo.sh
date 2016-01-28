#!/bin/bash

#sudo stuff
cp custom.desktop /usr/share/xsessions
rm /usr/share/X11/xkb/symbols/fi
ln -s xkb/fi /usr/share/X11/xkb/symbols/fi
cp xkb/keyboard /etc/default/
