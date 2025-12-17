package caverna;

class Caracol {

	int resistencia = 4;

	int deslizar(int metros) {
		return metros / 2;
	}

	int sugarVeneno(int quantidade) {
		this.resistencia = this.resistencia + quantidade;
		return this.resistencia;
	}
}
