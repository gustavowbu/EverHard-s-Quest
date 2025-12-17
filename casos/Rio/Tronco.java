package Rio;

class Tronco{

	int dureza = 5;

	int flutuar(int peso) {
		return this.dureza - peso;
	}

	int bater(int impacto) {
		return impacto * this.dureza;
	}

	int segurar(int forca) {
		return forca + this.dureza;
	}
}
