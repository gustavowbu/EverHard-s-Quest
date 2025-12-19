
class Bau {

	int capacidade = 5;
	int itens = 0;

	int guardar(int quantidade) {
		this.itens = this.itens + quantidade;
		return this.itens;
	}

	int abrir(int bonus) {
		return this.itens + bonus;
	}

	int herdar(int extra) {
		this.capacidade = this.capacidade + extra;
		return this.capacidade;
	}

	int trancar(int nivel) {
		return nivel * 2;
	}

	int esconder(int dificuldade) {
		return dificuldade + this.capacidade;
	}
    int trancarReforcado(int nivel, int material) {
		return nivel * material;
	}
}
