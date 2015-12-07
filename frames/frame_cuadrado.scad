N=4;
$fn=20;
Off=0.1;

module distribuye_rotando(radio, n) {
	for (i=[0:n-1]) rotate(i*360/n) translate([radio, 0, 0]) children();
}

module montura(modo, TotalDia, canteada=true) {
	// diametro del hueco del centro 
	CentroDia=0.8;
	// diametro del agujero de los 4 tornillos
	TornilloDia=0.3;
	// distancia entre dos aguneros de tornillos
	TornilloDistancia=1.4;
	// altura total de la montura
	Altura=0.1;
	
	PerfilAlto=0.5;
	PerfilAncho=0.1;

	if (modo == "crea") {
		// base plana de la montura del motor
		cylinder(r=TotalDia/2,h=Altura, center=true);

		// anillo alrededor del motor
		difference() {
			translate([0, 0, PerfilAlto/2])
			cylinder(r=TotalDia/2,h=PerfilAlto, center=true);
	
			translate([0, 0, 0.25])
			cylinder(r=TotalDia/2-PerfilAncho,h=PerfilAlto+2*Off, center=true);

			if (canteada) {
				// un plano inclinado para cortar inclinadamente
				rotate([0, 0, 180/N])
				rotate([0, 15, 0])
		      translate([0, 0, 4*PerfilAlto+0.3])
				cube([TotalDia, TotalDia, 4], center=true);
			}
		}
	}
	if (modo == "hueco") {
	   // hueco central
	   cylinder(r=CentroDia/2,h=Altura+2*Off, center=true);

	   // huecos 4 tornillos
		distribuye_rotando(TornilloDistancia/2, 4)
	   cylinder(r=TornilloDia/2,h=Altura+2*Off, center=true);
	}
}

module patas(modo, MontaTotalDia) {
	Alto=0.5;
	Diametro=0.4;
	Agujero=0.1;
	beta=180/N;
	gamma=90-180/N;
	if (modo == "crea") {
		for (angulo=[-1,1])
			rotate(beta+gamma*angulo)
		   translate([-MontaTotalDia/2, 0, Alto/2])
			cylinder(r=Diametro/2, h=Alto, center=true);
	}
	if (modo == "hueco") {
		for (angulo=[-1,1])
			rotate(beta+gamma*angulo)
	   	translate([-MontaTotalDia/2, 0, Alto/2])
			cylinder(r=Agujero/2, h=Alto+2*Off, center=true);
	}
}

module cable(modo, alto, base) {
   DiametroIntermedio=0.7;
	DiametroExterior=0.9;
	Agujero=0.5;
	Alto=0.2;

	if (modo == "crea") {
		translate([0, 0, alto-Alto/2])
		cylinder(r=DiametroExterior/2, h=Alto, center=true);
	}
	if (modo == "hueco") {
		// taladro central
		translate([0, 0, alto/2])
		cylinder(r=Agujero/2, h=alto+2*Off, center=true);
	}
}

module lados(modo, radio, MontaTotalDia) {
	// dimensiones de cada lado
	LadoAncho=1.0;
	LadoAlto=0.1;
	LadoPerfilAncho=0.2;
	LadoPerfilAlto=0.5;
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

module diagonales(modo, radio, MontaTotalDia) {
	// dimensiones de cada diagonal
	DiagonalAlto=0.1;
	DiagonalAncho=1.0;
	DiagonalPerfilAncho=0.2;
	DiagonalPerfilAlto=0.5;

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

module frame(modo, radio=9, MontaTotalDia=2.5) {
	if (modo == "crea") {
		for_rotate() {
			lados("crea", radio, MontaTotalDia);
			diagonales("crea", radio, MontaTotalDia);
			rotate_trans(radio) patas("crea", MontaTotalDia);
			rotate_trans(radio) montura("crea", MontaTotalDia);
		}
	}
	if (modo == "hueco") {
		for_rotate() {
			rotate_trans(radio) patas("hueco", MontaTotalDia);
			rotate_trans(radio) montura("hueco", MontaTotalDia);
		}
		diagonales("hueco", radio, MontaTotalDia);
	}
}

difference() { frame("crea"); frame("hueco"); }
//difference() { patas("crea"); patas("hueco"); }
//difference() { cable("crea", 0.5); cable("hueco", 0.1); }
//difference() { montura("crea", 2); montura("hueco", 2); }