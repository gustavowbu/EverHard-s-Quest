
class Minhoca {

	int comprimento = 2;
	int energia = 3;

	int morder(int forca) {
		return this.energia * forca ;
	}

	int esticar() {
		this.comprimento = this.comprimento + 1;
		return this.comprimento;
	}

	int comerFolhas() {
		this.energia = this.energia + 1;
		return this.energia;
	}

	String esconder() {
		return "A minhoca se escondeu no solo";
	}
}
