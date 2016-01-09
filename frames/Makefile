SLIC3R_FLAGS:=--load config.ini
SCAD_IMG_FLAGS:=--imgsize=1024,700 --projection=p --camera=0,0,0,60,0,14,80 --render 
SCAD_IMG_FLAGS:=--imgsize=1024,700 --projection=p

TARGETS=$(patsubst %.scad, %, $(wildcard *.scad))
GCODES=$(patsubst %, %.gcode, $(TARGETS))
PNGS=$(patsubst %, %.png, $(TARGETS))
PROJECT=$(shell basename `pwd`)

PENDRIVE=/dev/sdb1

all: $(PNGS) $(GCODES)

clean:
	rm -f $(GCODES) $(PNGS) *.stl

%.stl: %.scad
	openscad -o $@ $<
%.gcode: %.stl
	slic3r $(SLIC3R_FLAGS) $< -o $@
%.png: %.scad
	openscad -o $@ $(SCAD_IMG_FLAGS) $<
copy: all
	pmount $(PENDRIVE) pendrive
	mkdir -p /media/pendrive/$(PROJECT)
	cp $(GCODES) /media/pendrive/$(PROJECT)
	pumount /media/pendrive
