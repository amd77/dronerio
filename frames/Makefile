SLIC3R_FLAGS:=--load bq_hephestos_2_PLA_high_quality.ini
SCAD_IMG_FLAGS:=--imgsize=1024,700 --projection=p --camera=0,0,0,60,0,14,80 --render 
SCAD_IMG_FLAGS:=--imgsize=1024,700 --projection=p

TARGETS=$(patsubst %.scad, %, $(wildcard *.scad))

all: $(patsubst %, %.png, $(TARGETS)) $(patsubst %, %.gcode, $(TARGETS))

clean:
	rm -f *.gcode *.png *.stl

%.stl: %.scad
	openscad -o $@ $<
%.gcode: %.stl
	slic3r $(SLIC3R_FLAGS) $< -o $@
%.png: %.scad
	openscad -o $@ $(SCAD_IMG_FLAGS) $<
