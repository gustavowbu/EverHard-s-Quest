extends Node
class_name JavaDataType

var classe: String
var mutable := false

func repr() -> String:
	var result = toString()
	if result.classe == "Exception":
		return result.get_message()
	return result.value

func toString() -> JavaDataType:
	return ExceptionJDT.new("", "Não é possível converter para String")

func toInt() -> JavaDataType:
	return ExceptionJDT.new("", "Não é possível converter para int")

func toBoolean() -> JavaDataType:
	return ExceptionJDT.new("", "Não é possível converter para boolean")

func add(other: JavaDataType) -> JavaDataType:
	return ExceptionJDT.new("", "O operador + não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)

func subtract(other: JavaDataType) -> JavaDataType:
	return ExceptionJDT.new("", "O operador - não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)

func multiply(other: JavaDataType) -> JavaDataType:
	return ExceptionJDT.new("", "O operador * não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)

func divide(other: JavaDataType) -> JavaDataType:
	return ExceptionJDT.new("", "O operador / não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)

func inverse() -> JavaDataType:
	return ExceptionJDT.new("", "O operador - não é definido para o(s) tipo(s) de argumento(s) " + classe)

func equals(_other: JavaDataType) -> BooleanJDT:
	return BooleanJDT.new(false)

func different(other: JavaDataType) -> JavaDataType:
	return equals(other).inverse()

func greater_than(other: JavaDataType) -> JavaDataType:
	return ExceptionJDT.new("", "O operador > não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)

func less_than(other: JavaDataType) -> JavaDataType:
	return ExceptionJDT.new("", "O operador < não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)

func greater_than_or_equal(other: JavaDataType) -> JavaDataType:
	return ExceptionJDT.new("", "O operador >= não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)

func less_than_or_equal(other: JavaDataType) -> JavaDataType:
	return ExceptionJDT.new("", "O operador <= não é definido para o(s) tipo(s) de argumento(s) " + classe + ", " + other.classe)
