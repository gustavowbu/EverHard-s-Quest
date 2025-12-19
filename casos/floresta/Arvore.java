class Arvore {
	int altura = 3;
	int galhos = 2;

	int crescer() {
		this.galhos = this.galhos * 10;
		return this.galhos;
	}

	String quebrarGalho() {
		return "Galho quebrado";
	}

	int fotossintese() {
		this.altura = this.altura + 1;
		return this.altura;
	}

	int cair() {
		return this.altura + this.galhos;
	}

	String balancar(String nome) {
		return nome + ", o Grande!";
	}
}
