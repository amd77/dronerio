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

module montura(modo, TotalDia) {
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
            translate([-TotalDia*0.75, 0, 0])
            cube([TotalDia/6, TotalDia*1.8, Altura], center=true);
        }
		// anillo alrededor del motor
        translate([0, 0, PerfilAlto/2])
        cylinder(d=TotalDia,h=PerfilAlto, center=true);
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

		// hueco anillo alrededor del motor
       translate([0, 0, PerfilAlto/2+2*Off])
       cylinder(d=TotalDia-2*PerfilAncho,h=PerfilAlto+2*Off, center=true);
	}
}

module patas(modo, MontaTotalDia) {
	Alto=5.5;
	Diametro=4;
	Agujero=1.5;
	beta=180/N;
	gamma=90-180/N;
    for (angulo=[-1, 1, 4])
        rotate(beta+gamma*angulo)
        translate([-MontaTotalDia/1.7-Diametro/3, 0, Alto/2-0.5])
        cylinder_with_hole(modo, Alto, Diametro*1.30, Diametro, Agujero);
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

module frame(modo, radio=100, MontaTotalDia=25, hacer_aspa=false) {
    for_rotate() {
        lados(modo, radio, MontaTotalDia);
        multiwii(modo, 25.1, 5);
        diagonales(modo, radio, MontaTotalDia);
        if (modo == "crea") {
            rotate_trans(radio) hull() patas(modo, MontaTotalDia);
        }
        if (modo == "hueco") {
            rotate_trans(radio) patas(modo, MontaTotalDia);
        }
        rotate_trans(radio) montura(modo, MontaTotalDia);
        if (hacer_aspa) rotate_trans(radio) aspa(modo);
    }
}

module cylinder_with_hole(modo, h, r1, r2, hole, center=true) {
    if (modo == "crea") {
        cylinder(r1=r1, r2=r2, h=h, center=center);
    }
    if (modo == "hueco") {
        cylinder(r=hole, h=h*1.5, center=center);
    }
}

difference() { frame("crea"); frame("hueco"); }
//difference() { cable("crea", 5); cable("hueco", 1); }
//difference() { montura("crea", 20); montura("hueco", 20); }
