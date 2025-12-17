package caverna;

class SapoGigante {

	int peso = 8;

	int pular(int distancia) {
		return distancia - this.peso;
	}

	int esmagar(int forca) {
		return this.peso * forca;
	}

	int golpear(int impacto) {
		return impacto + this.peso;
	}

	int engolir(int tamanho) {
		return tamanho * 2;
	}
}
