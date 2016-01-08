N=4;
$fn=30;
Off=1;

module distribuye_rotando(radio, n) {
	for (i=[0:n-1]) rotate(i*360/n) translate([radio, 0, 0]) children();
}

module aspa(modo, diametro=127, elevacion=21, altura=10) {
    translate([0, 0, elevacion+altura/2]) {
        if (modo == "crea") {
            %cylinder(d=diametro, h=altura, center=true);
        }
        if (modo == "hueco") {
        }
    }
}

module montura(modo, TotalDia, canteada=false) {
	// diametro del hueco del centro 
	CentroDia=8;
	// diametro del agujero de los 4 tornillos
	TornilloDia=3;
	// distancia entre dos aguneros de tornillos
	TornilloDistancia=14;
	// altura total de la montura
	Altura=1;
	
	PerfilAlto=5;
	PerfilAncho=1;

	if (modo == "crea") {
		// base plana de la montura del motor
        hull() {
            cylinder(d=TotalDia,h=Altura, center=true);

            rotate([0, 0, 180/N])
            translate([-TotalDia/3, 0, 0])
            cylinder(d=TotalDia, h=Altura, center=true);
        }
		// anillo alrededor del motor
		difference() {
			translate([0, 0, PerfilAlto/2])
			cylinder(d=TotalDia,h=PerfilAlto, center=true);
	
			translate([0, 0, 2.5])
			cylinder(d=TotalDia-2*PerfilAncho,h=PerfilAlto+2*Off, center=true);

			if (canteada) {
				// un plano inclinado para cortar inclinadamente
				rotate([0, 0, 180/N])
				rotate([0, 10, 0])
		        translate([0, 0, 4*PerfilAlto+4])
				cube([TotalDia, TotalDia, 40], center=true);
			}
		}
	}
	if (modo == "hueco") {
	   // hueco central
	   cylinder(d=CentroDia,h=Altura+2*Off, center=true);

	   // huecos 4 tornillos
		distribuye_rotando(TornilloDistancia/2, 4)
	   cylinder(d=TornilloDia,h=Altura+2*Off, center=true);
            rotate([0, 0, 180/N])
            rotate([0, 70, 0])
            translate([-4, 0, -9])
            cube([2.5, 7, 20], center=true);
	}
}

module patas(modo, MontaTotalDia) {
	Alto=5;
	Diametro=4;
	Agujero=1.5;
	beta=180/N;
	gamma=90-180/N;
	if (modo == "crea") {
		for (angulo=[-1,1])
			rotate(beta+gamma*angulo)
		    translate([-MontaTotalDia/1.6-Diametro/3, 0, Alto/2])
			//cylinder(d=Diametro, h=Alto, center=true);
            cylinder_with_hole(modo, Alto, Diametro*1.5, Diametro, Agujero);
	}
	if (modo == "hueco") {
		for (angulo=[-1,1])
			rotate(beta+gamma*angulo)
	   	    translate([-MontaTotalDia/1.6-Diametro/3, 0, Alto/2])
			//cylinder(d=Agujero, h=Alto+2*Off, center=true);
            cylinder_with_hole(modo, Alto, Diametro*1.5, Diametro, Agujero);
	}
}

module cable(modo, alto, base) {
	DiametroExterior=13;
	Agujero=10;
	Alto=alto;

	if (modo == "crea") {
		translate([0, 0, alto-Alto/2])
		cylinder(d=DiametroExterior, h=Alto, center=true);
	}
	if (modo == "hueco") {
		// taladro central
		translate([0, 0, alto/2])
		cylinder(d=Agujero, h=alto+2*Off, center=true);
	}
}

module lados(modo, radio, MontaTotalDia) {
	// dimensiones de cada lado
	LadoAncho=10;
	LadoAlto=1;
	LadoPerfilAncho=2;
	LadoPerfilAlto=5;
    lado=radio*sqrt(2*(1-cos(360/N)));
    apotema=radio*cos(360/N/2);
	lado2=lado-MontaTotalDia*0.9;
	if (modo == "crea") {
		// parte plana cuadrada exterior
		translate([apotema, 0, -LadoAlto/2])
		rotate(90)
		translate([-lado/2, -LadoAncho/2, 0])
		cube([lado, LadoAncho, LadoAlto]);

        // nervio superior cuadrado exterior
		translate([apotema, 0, -LadoPerfilAlto/2])
		rotate(90)
		translate([-lado2/2, -LadoPerfilAncho/2, LadoPerfilAlto/2])
		cube([lado2, LadoPerfilAncho, LadoPerfilAlto]);

	}
	if (modo == "hueco") {
	}
}

module multiwii(modo, radio, altura) {
    agujero=1.5;
    soporte=1.3;
    exterior=soporte*2+agujero;
    rotate(45)
    translate([radio, 0, altura/2])
    cylinder_with_hole(modo, h=altura, r1=exterior*1.25, r2=exterior, hole=agujero);
}

module diagonales(modo, radio, MontaTotalDia) {
	// dimensiones de cada diagonal
	DiagonalAlto=1;
	DiagonalAncho=10;
	DiagonalPerfilAncho=2;
	DiagonalPerfilAlto=5;

	if (modo == "crea") {
		// parte plana diagonales
		rotate([0, 0, 180/N])
		translate([radio/2, 0, 0])
		cube([radio, DiagonalAncho, DiagonalAlto], center=true);

		// nervio superior diagonales
		rotate([0, 0, 180/N])
		translate([radio/2-MontaTotalDia/4, 0, DiagonalPerfilAlto/2])
		cube([radio-MontaTotalDia/2*0.85, DiagonalPerfilAncho, DiagonalPerfilAlto], center=true);

		cable("crea", DiagonalPerfilAlto, DiagonalAlto);
	}
	if (modo == "hueco") {
		cable("hueco", DiagonalPerfilAlto, DiagonalAlto);
	}
}

module for_rotate() {
	for (i=[0:N-1])
	rotate(i*360/N)
	children();
}

module rotate_trans(radio) {
	rotate(180/N) 
    translate([radio, 0, 0])
	rotate(-180/N)
	children();
}

module cylinder_angle(r, h, angle=120, trans=[0,0,0]) {
    rotate(180/N)
    translate(trans)
    rotate(-angle/2)
    rotate_extrude(angle=angle) {
        square(size=[r, h], center=false);
        // polygon(points=[[0, 0], [h, 0], [h, r], [0, r]]);
    }
}

module subpata(altura, cilindro_x, cosa, angle, grueso, base, longitud) {
    translate([0, 0, -altura/2]) 
    rotate([0, 0, 180/N]) 
    translate([-cilindro_x/2+cosa, 0, 0]) 
    rotate([0, angle, 0]) 
    cube([grueso, base[1], longitud], center=true);
}

module pata(modo, angle=10, cosa=12) {
    radio_base = 5;
    altura_base = 8;
    altura = 60;
    longitud = altura/cos(angle);
    base = [4, 9];
    grueso = 1;
    factor1 = 0;
    factor2 = 0;
    factorx = (1-factor1-factor2);
    cilindro_x = longitud * sin(angle);
    translate([0, 0, -grueso]) {
        if (modo == "crea") {
            // parte inclinada larga
            subpata(altura, cilindro_x, cosa, angle, grueso, base, longitud);
            // parte que pega al chasis
            hull() {
                rotate(180/N) translate([base[1]+grueso, 0, 0]) cube([base[0], base[1], 1], center=true);
                intersection() {
                    translate([-50, -50, -altura_base]) cube([100,100,altura_base]);
                    subpata(altura, cilindro_x, cosa, angle, grueso, base, longitud);
                }
            }
            // parte que va al suelo
            hull() {
                cylinder_angle(radio_base, altura_base, trans=[-cilindro_x-radio_base+cosa, 0, -altura]);
                intersection() {
                    translate([-50, -50, -altura]) cube([100,100,altura_base]);
                    subpata(altura, cilindro_x, cosa, angle, grueso, base, longitud);
                }
            }
        }
        if (modo == "hueco") {
            translate([0, 0, -altura+altura_base/2])
            rotate([90, 0, 180/N])
            translate([-cilindro_x+12, 0, 0])
            cylinder(d=2, h=10, center=true);
        }
    }
}

module frame(modo, radio=95, MontaTotalDia=25, hacer_aspa=false) {
    for_rotate() {
        lados(modo, radio, MontaTotalDia);
        multiwii(modo, 25.1, 5);
        diagonales(modo, radio, MontaTotalDia);
        // rotate_trans(radio) pata(modo, angle=17);
        // rotate_trans(radio) translate([-28, -3, 0]) rotate([0, 0, 120]) pata(modo, angle=24);
        // rotate_trans(radio) translate([-3, -28, 0]) rotate([0, 0, -120]) pata(modo, angle=24);
        rotate_trans(radio) patas(modo, MontaTotalDia);
        rotate_trans(radio) montura(modo, MontaTotalDia);
        if (hacer_aspa) rotate_trans(radio) aspa(modo);
    }
}

module pata_centrada(modo, angle) {
    rotate([0, 90, 0]) 
    translate([0, 0, 30]) 
    rotate([0, -angle, 0]) 
    translate([-12.5, 0, 0]) 
    rotate([0, 0, -45]) 
    pata(modo, angle=angle);
}

module imprime_patas(modo, angle=24, count=1) {
    for (i=[1:count])
        translate([0, (i-count/2-0.5)*10, 0]) pata_centrada(modo,angle=angle);
}

module cylinder_with_hole(modo, h, r1, r2, hole, center=true) {
    if (modo == "crea") {
        cylinder(r1=r1, r2=r2, h=h, center=center);
    }
    if (modo == "hueco") {
        cylinder(r=hole, h=h*1.5, center=center);
    }
}

//cylinder_with_hole(r1=20, r2=10, h=15, hole=7);

difference() { frame("crea"); frame("hueco"); }
//difference() { imprime_patas("crea"); imprime_patas("hueco"); }
//difference() { pata("crea"); pata("hueco"); }
//difference() { patas("crea"); patas("hueco"); }
//difference() { cable("crea", 5); cable("hueco", 1); }
//difference() { montura("crea", 20); montura("hueco", 20); }
