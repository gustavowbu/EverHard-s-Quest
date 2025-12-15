extends JavaDataType
class_name ArrayJDT

# All values inside this array must be JavaDataTypes

var value := []

func _init(value_in: Array = []) -> void:
	classe = "Array"
	mutable = true
	value = value_in

func toString() -> JavaDataType:
	var result = "["
	for i in range(len(value)):
		var element = value[i]
		result += element.repr()
		if i != len(value) - 1:
			result += ", "
	result += "]"
	return StringJDT.new(result)

func add(other: JavaDataType) -> JavaDataType:
	if other.classe != classe:
		return ExceptionJDT.new("", "O operador + não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)
	return IntJDT.new(value + other.value)

func equals(other: JavaDataType) -> BooleanJDT:
	if other.classe != classe:
		return BooleanJDT.new(false)
	if length() != other.length():
		return BooleanJDT.new(false)
	for i in range(length()):
		if value[i].different(other.value[i]):
			return BooleanJDT.new(false)
	return BooleanJDT.new(true)

func copy() -> ArrayJDT:
	var value_out = []
	for i in range(length()):
		if value[i].mutable:
			value_out.append(value[i].copy())
		else:
			value_out.append(value[i])
	return ArrayJDT.new(value_out)

func length() -> IntJDT:
	return IntJDT.new(len(value))

func append(element) -> void:
	value.append(element)

func insert(element, index := IntJDT.new(0)):
	if index.less_than(IntJDT.new(0)) or index.greater_than(length()):
		return ExceptionJDT.new("", "índice " + index.repr() + " fora de escopo")
	value.insert(index.value, element)

func pop(index: IntJDT) -> JavaDataType:
	if _is_valid_index(index).value:
		value.pop_at(index.value)
		return self
	else:
		return ExceptionJDT.new("", "índice de array fora de escopo")

func getElement(index: IntJDT) -> JavaDataType:
	if _is_valid_index(index).value:
		return value[index.value]
	else:
		return ExceptionJDT.new("", "índice de array fora de escopo")

func _is_valid_index(index: IntJDT) -> BooleanJDT:
	if index.less_than(IntJDT.new(0)):
		index = index.inverse().subtract(IntJDT.new(1))
	if index.less_than(length()):
		return BooleanJDT.new(true)
	return BooleanJDT.new(false)
