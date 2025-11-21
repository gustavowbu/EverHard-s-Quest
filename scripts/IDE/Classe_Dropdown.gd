extends Dropdown

func _ready():
	for i in range(4):
		add_dropdown("Método " + str(i + 1))
	for i in range(len(elements)):
		elements[i].add_leaf("Caso de teste 1")
	update()
