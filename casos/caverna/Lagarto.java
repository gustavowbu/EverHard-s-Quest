
class Lagarto {

	int camuflagem = 3;
	int velocidade = 4;

	int camuflar(int ambiente) {
		return this.camuflagem * ambiente;
	}

	int correr(int tempo) {
		return this.velocidade * tempo;
	}

	int morder(int forca) {
		return forca + this.velocidade;
	}
}
