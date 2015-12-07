SLIC3R_FLAGS:=--load frame_cuadrado.ini
SCAD_IMG_FLAGS:=--imgsize=1024,700 --projection=p --camera=0,0,0,60,0,14,80 --render 
SCAD_IMG_FLAGS:=--imgsize=1024,700 --projection=p --camera=0,0,0,60,0,14,1000

all: frame_cuadrado frame_cuadrado_trozo

frame_cuadrado: frame_cuadrado.gcode frame_cuadrado.png

frame_cuadrado_trozo: frame_cuadrado_trozo.gcode frame_cuadrado_trozo.png

clean:
	rm -f *.gcode *.png

%.stl: %.scad
	openscad -o $@ $<
%.gcode: %.stl
	slic3r $(SLIC3R_FLAGS) $< -o $@
%.png: %.scad
	openscad -o $@ $(SCAD_IMG_FLAGS) $<
