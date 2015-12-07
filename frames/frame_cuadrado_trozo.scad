use <frame_cuadrado.scad>;

module presenta_cacho() {
    translate([-60,-60,0])
    intersection() {
        difference() { frame("crea"); frame("hueco"); }
        translate([62,62,0])
        cylinder(r=20, h=10, center=true);
    }
}

presenta_cacho();
