extends JavaDataType
class_name CharJDT

var value: String

func _init(value_in: String) -> void:
	classe = "String"
	if len(value_in) != 1:
		value = "Constante de caractere inválida"
	else:
		value = value_in

func is_valid() -> bool:
	return len(value) == 1

func error() -> JavaDataType:
	if not is_valid():
		return ExceptionJDT.new("", value)
	return self

func toString() -> JavaDataType:
	if not is_valid():
		return error()
	return StringJDT.new(value)

func toInt() -> JavaDataType:
	if value.is_valid_int():
		return IntJDT.new(int(value))
	return ExceptionJDT.new("", "Não é possível comverter para int")

func equals(other: JavaDataType) -> BooleanJDT:
	if other.classe != classe:
		return BooleanJDT.new(false)
	return BooleanJDT.new(value == other.value)
