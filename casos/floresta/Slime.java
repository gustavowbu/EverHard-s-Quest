
class Slime {
	int massa = 3;

	int pular(int altura) {
		return altura * this.massa;
	}

	int dividir() {
		this.massa = this.massa / 2;
		return this.massa;
	}

	String grudar() {
		return "Slime grudou no alvo";
	}

	int derreter() {
		this.massa = this.massa - 1;
		return this.massa;
	}
}