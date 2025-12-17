
class Cogumelo {

	int toxina = 3;

	int envenenar(int alvo) {
		return alvo * this.toxina;
	}

	int espalhar(int area) {
		return area + this.toxina;
	}

	int comer(int energia) {
		return energia + 1;
	}
    boolean sobrevive(int energia, int dano) {
        int aux = energia - dano ;
        return  aux > 0;
	}
}
