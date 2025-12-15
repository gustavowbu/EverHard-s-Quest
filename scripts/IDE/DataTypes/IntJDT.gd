extends JavaDataType
class_name IntJDT

var value: int

func _init(value_in: int) -> void:
	classe = "int"
	value = value_in

func toString() -> StringJDT:
	return StringJDT.new(str(value))

func toInt() -> IntJDT:
	return self

func toBoolean() -> BooleanJDT:
	return BooleanJDT.new(value != 0)

func add(other: JavaDataType) -> JavaDataType:
	if not other.classe in ["int", "double"]:
		return ExceptionJDT.new("", "O operador + não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)
	return IntJDT.new(value + other.value)

func subtract(other: JavaDataType) -> JavaDataType:
	if not other.classe in ["int", "double"]:
		return ExceptionJDT.new("", "O operador - não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)
	return IntJDT.new(value - other.value)

func multiply(other: JavaDataType) -> JavaDataType:
	if not other.classe in ["int", "double"]:
		return ExceptionJDT.new("", "O operador * não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)
	return IntJDT.new(value * other.value)

func divide(other: JavaDataType) -> JavaDataType:
	if not other.classe in ["int", "double"]:
		return ExceptionJDT.new("", "O operador / não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)
	return IntJDT.new(value / other.value)

func inverse() -> IntJDT:
	return IntJDT.new(-value)

func equals(other: JavaDataType) -> BooleanJDT:
	if not other.classe in ["int", "double"]:
		return BooleanJDT.new(false)
	return BooleanJDT.new(value == other.value)

func greater_than(other: JavaDataType) -> JavaDataType:
	if not other.classe in ["int", "double"]:
		return ExceptionJDT.new("", "O operador > não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)
	return BooleanJDT.new(value > other.value)

func less_than(other: JavaDataType) -> JavaDataType:
	if not other.classe in ["int", "double"]:
		return ExceptionJDT.new("", "O operador < não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)
	return BooleanJDT.new(value < other.value)

func greater_than_or_equal(other: JavaDataType) -> JavaDataType:
	if not other.classe in ["int", "double"]:
		return ExceptionJDT.new("", "O operador >= não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)
	return BooleanJDT.new(value >= other.value)

func less_than_or_equal(other: JavaDataType) -> JavaDataType:
	if not other.classe in ["int", "double"]:
		return ExceptionJDT.new("", "O operador <= não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)
	return BooleanJDT.new(value <= other.value)
