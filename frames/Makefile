TARGETS:=frame_cuadrado.stl frame_cuadrado_3.png frame_cuadrado_4.png frame_cuadrado_6.png

all: $(TARGETS)

clean:
	rm -f $(TARGETS)

frame_cuadrado.stl: frame_cuadrado.scad
	openscad -o $@ $<
frame_cuadrado_3.png: frame_cuadrado.scad
	openscad -D N=3 -o $@ --imgsize=1024,700 --projection=p --camera=0,0,0,60,0,14,80 --render $<
frame_cuadrado_4.png: frame_cuadrado.scad
	openscad -D N=4 -o $@ --imgsize=1024,700 --projection=p --camera=0,0,0,60,0,14,80 --render $<
frame_cuadrado_6.png: frame_cuadrado.scad
	openscad -D N=6 -o $@ --imgsize=1024,700 --projection=p --camera=0,0,0,60,0,14,80 --render $<
