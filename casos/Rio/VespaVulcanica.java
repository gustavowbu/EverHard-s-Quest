
class VespaVulcanica extends Vespa {

	int temperatura = 5;

	// POLIMORFISMO: mesmo método, outro comportamento
	@Override
	int voar(int tempo) {
		return tempo * this.temperatura;
	}

	// POLIMORFISMO: mesmo método, outro comportamento
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
