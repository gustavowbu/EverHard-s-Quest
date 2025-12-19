
class Borboleta {

	int energia = 4;

	int voar(int tempo) {
		this.energia = this.energia - tempo;
		return this.energia;
	}

	int transformar(int nivel) {
		return nivel * 2;
	}

	int polinizar(int flores) {
		return flores * this.energia;
	}
    int voarComEsforco(int tempo, int vento) {
		this.energia = this.energia - tempo;
		return this.energia - vento;
	}
    boolean podeVoar(int custo) {
		return this.energia >= custo;
	}
}
