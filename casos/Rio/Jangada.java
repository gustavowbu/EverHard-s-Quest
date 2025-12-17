package Rio;

class Jangada {

	int estabilidade = 4;

	int flutuar(int peso) {
		return this.estabilidade - peso;
	}

	int transportar(int carga) {
		return carga * this.estabilidade;
	}

	int remar(int forca) {
		return forca + this.estabilidade;
	}
}
