package floresta;
class Passaro {

	int energia = 3;
	int velocidade = 4;

	String voar() {
		this.energia = this.energia - 1;
		return "O pássaro está voando";
	}

	int bicar() {
		return this.velocidade * this.energia;
	}

	boolean pousar() {
		this.energia = this.energia + 1;
		return true;
	}

    int cantar() {
        return this.energia * 2;
    }
}