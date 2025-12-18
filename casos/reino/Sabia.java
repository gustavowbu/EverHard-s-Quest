
class Sabia extends Passaro {

	int assobiar(int intensidade) {
		return intensidade + this.energia;
	}
    int assobiarAfinado(int intensidade, int tom) {
		return intensidade + tom;
	}
    boolean consegueAssobiar(int custo) {
		return this.energia >= custo;
	}
}
