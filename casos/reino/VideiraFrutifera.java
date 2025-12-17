package reino;

class VideiraFrutifera extends Grama {

	int frutos = 2;

	int enrolar(int forca) {
		return forca * this.area;
	}

	int gerarFrutos(int quantidade) {
		this.frutos = this.frutos + quantidade;
		return this.frutos;
	}

	int prender(int resistencia) {
		return resistencia + this.frutos;
	}
}
