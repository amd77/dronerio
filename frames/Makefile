TARGETS:=frame_cuadrado.gcode frame_cuadrado_trozo.gcode frame_cuadrado.png
SLIC3R:=frame_cuadrado.ini
SCAD_IMG_FLAGS:=--imgsize=1024,700 --projection=p --camera=0,0,0,60,0,14,80 --render 

all: $(TARGETS)

clean:
	rm -f $(TARGETS)

%.stl: %.scad
	openscad -o $@ $<
%.gcode: %.stl
	slic3r --load $(SLIC3R) $< -o $@
%.png: %.scad
	openscad -o $@ $(SCAD_IMG_FLAGS) $<
