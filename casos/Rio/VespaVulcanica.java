package Rio;

class VespaVulcanica extends Vespa {

	int temperatura = 5;

	int cuspirFogo(int intensidade) {
		return intensidade * this.temperatura;
	}

	int derreter(int resistencia) {
		return this.temperatura - resistencia;
	}
}
