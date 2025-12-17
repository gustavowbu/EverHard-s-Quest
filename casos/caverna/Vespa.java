package caverna;

class Vespa {

	int agressividade = 5;

	int voar(int tempo) {
		return tempo * 2;
	}

	int partirPraCima(int impulso) {
		return this.agressividade * impulso;
	}

	int ferroar(int forca) {
		return forca + this.agressividade;
	}
}
