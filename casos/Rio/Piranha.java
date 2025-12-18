
class Piranha extends Peixe {

	int agressividade = 3;

	
	int nadar(int tempo) {
		return (this.velocidade + this.agressividade) * tempo;
	}

	
	int partirPraCima(int forca) {
		return forca + this.velocidade + this.agressividade;
	}

	int morder(int forca) {
		return forca * this.agressividade;
	}

	int traicao(int surpresa) {
		return surpresa + this.agressividade;
	}
}
