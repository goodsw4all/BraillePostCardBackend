# Copyright 2015 Elena Grandi
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

# Usage : make PLAINTEXT=[\"I\"\,\ \"Love\"\,\ \"U\"]
BUILDDIR = build
CONFDIR = conf
SRCDIR = src

SLIC3R = /Applications/Slic3r.app/Contents/MacOS/slic3r
OPENSCAD =/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
#PLAINTEXT?=["A", "B", "C"]
PLAINTEXT?=["LOVE"]

STL_TARGETS = $(patsubst %.scad,%.stl,$(wildcard *.scad))
GCODE_TARGETS = $(patsubst %.scad,%.gcode,$(wildcard *.scad))

.PHONY: all stl gcode clean
all: stl gcode

stl: $(STL_TARGETS)

gcode: $(GCODE_TARGETS)

%.stl: %.scad
	$(OPENSCAD) -o $@ -D 'message=$(PLAINTEXT)' $<

#slic3r my_model.stl --load my_config.ini --fill-pattern concentric
%.gcode: %.stl
	$(SLIC3R) $< -o $@ --load config.ini --fill-pattern concentric --print-center 0,0

clean:
	rm -f *.stl *.gcode
