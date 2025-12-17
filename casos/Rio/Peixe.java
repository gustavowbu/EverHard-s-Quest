package Rio;

class Peixe {

	int velocidade = 4;

	int nadar(int tempo) {
		return this.velocidade * tempo;
	}

	int mergulhar(int profundidade) {
		return profundidade + this.velocidade;
	}

	int partirPraCima(int forca) {
		return forca + this.velocidade;
	}
}
