package caverna;

class Aranha {

	int fios = 3;

	int tecer(int x) {
		this.fios = this.fios + x;
		return this.fios;
	}

	int prender(int forca) {
		return this.fios * forca;
	}

	int morder(int veneno) {
		return veneno * 2;
	}
}
