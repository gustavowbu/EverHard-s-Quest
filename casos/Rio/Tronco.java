package Rio;

class Tronco extends Arvore {

	int dureza = 5;

	
	@Override
	int atacar() {
		return this.dureza * 10;
	}

	@Override
	String cair() {
	
		return "Tronco já caiu faz tempo";
	}

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
