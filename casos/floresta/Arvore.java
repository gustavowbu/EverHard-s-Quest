class Arvore {

	int altura = 3;
	int galhos = 2;

	int atacar() {
		return this.galhos * 10;
	}

	String quebrarGalho() {
		return "Galho quebrado";
	}

	int fotossintese() {
		this.altura = this.altura + 1;
		return this.altura;
	}

	int cair() {
		this.altura = 0;
		this.galhos = 0;
		int soma = this.altura + this.galhos;
		return soma;
	}
}
