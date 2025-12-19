extends JavaDataType
class_name StringJDT

var value := ""

func _init(value_in := "") -> void:
	classe = "String"
	value = value_in

func toString() -> StringJDT:
	return self

func toInt() -> JavaDataType:
	if value.is_valid_int():
		return IntJDT.new(int(value))
	return ExceptionJDT.new("", "Não é possível converter para int")

func toBoolean() -> BooleanJDT:
	if value == "true":
		return BooleanJDT.new(true)
	else:
		return BooleanJDT.new(false)

func add(other: JavaDataType) -> JavaDataType:
	if other.classe != classe:
		return ExceptionJDT.new("", "O operador + não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)
	return StringJDT.new(value + other.value)

func equals(other: JavaDataType) -> BooleanJDT:
	if other.classe != classe:
		return BooleanJDT.new(false)
	return BooleanJDT.new(value == other.value)

func length() -> IntJDT:
	return IntJDT.new(len(value))

func begins_with(substring: StringJDT) -> BooleanJDT:
	return BooleanJDT.new(value.begins_with(substring.value))

func charAt(index: IntJDT) -> CharJDT:
	return CharJDT.new(value[index.value])

func concat(other: JavaDataType) -> JavaDataType:
	return add(other)

func contains(other: JavaDataType) -> JavaDataType:
	if other.classe != classe:
		return ExceptionJDT.new("", "O método contains(String) do tipo String não é aplicável para os argumentos (" + other.classe + ")")
	return BooleanJDT.new(value.contains(other.value))

func substr(from: IntJDT, len_in := IntJDT.new(-1)) -> StringJDT:
	return StringJDT.new(value.substr(from.value, len_in.value))

func isEmpty() -> BooleanJDT:
	return BooleanJDT.new(value == "")
