package Rio;

class Piranha extends Peixe {

	int agressividade = 3;

	int morder(int forca) {
		return forca * this.agressividade;
	}

	int traicao(int surpresa) {
		return surpresa + this.agressividade;
	}
}
