
class VespaVulcanica extends Vespa {

	int temperatura = 5;

	
	int voar(int tempo) {
		return tempo * this.temperatura;
	}

	
	int ferroar(int forca) {
		return forca + this.agressividade + this.temperatura;
	}

	int cuspirFogo(int intensidade) {
		return intensidade * this.temperatura;
	}

	int derreter(int resistencia) {
		return this.temperatura - resistencia;
	}
	Peixe capturar(Peixe p) {
		return p;
	}
}
