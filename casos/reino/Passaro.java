package reino;

class Passaro {

	int energia = 5;
	int velocidade = 4;

	int voar(int tempo) {
		this.energia = this.energia - tempo;
		return this.energia;
	}

	int bicar(int forca) {
		return this.velocidade * forca;
	}
}
