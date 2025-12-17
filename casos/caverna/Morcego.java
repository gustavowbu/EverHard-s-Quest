package caverna;

class Morcego {

	int energia = 5;

	int voar(int tempo) {
		this.energia = this.energia - tempo;
		return this.energia;
	}

	int pendurar(int descanso) {
		this.energia = this.energia + descanso;
		return this.energia;
	}

	int jogarSemente(int distancia) {
		return distancia * 2;
	}
}
