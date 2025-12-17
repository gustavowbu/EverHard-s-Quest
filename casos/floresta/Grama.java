
class Grama {

	int area = 2;

	int crescer(int fator) {
		this.area = this.area + fator;
		return this.area;
	}

	String espalhar() {
		return "A grama se espalhou pelo terreno";
	}

	int fotossintese() {
		this.area = this.area + 1;
		return this.area;
	}
}
