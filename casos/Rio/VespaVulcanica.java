package Rio;
from caverna import Vespa;

class VespaVulcanica extends Vespa {

	int temperatura = 5;

	@Override
	int voar(int tempo) {
		return tempo * this.temperatura;
	}

	@Override
	int ferroar(int forca) {
		return forca + this.agressividade + this.temperatura;
	}

	int cuspirFogo(int intensidade) {
		return intensidade * this.temperatura;
	}

	int derreter(int resistencia) {
		return this.temperatura - resistencia;
	}
}
