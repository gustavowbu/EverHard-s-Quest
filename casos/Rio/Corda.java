package Rio;

class Corda {

	int resistencia = 6;

	int amarrar(int forca) {
		return forca * this.resistencia;
	}

	int puxar(int peso) {
		return this.resistencia - peso;
	}

	int saltar(int altura) {
		return altura + this.resistencia;
	}

	int lacar(int alvo) {
		return alvo * 2;
	}
}
