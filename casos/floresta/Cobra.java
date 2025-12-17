package floresta;
class Cobra {

	int veneno = 3;
	int comprimento = 2;
	int energia = 4;

	int rastejar() {
		return this.energia  = this.energia - 1;
	}

	int atacar() {
		return this.veneno * this.comprimento;
	}

	String enrolar() {
		return "Cobra enrolou o alvo";
	}

	int aumentarVeneno() {
		this.veneno = this.veneno + 1;
		return this.veneno;
	}
}
