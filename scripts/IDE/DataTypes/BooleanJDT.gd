extends JavaDataType
class_name BooleanJDT

var value: bool

func _init(value_in: bool) -> void:
	classe = "boolean"
	value = value_in

func toString() -> JavaDataType:
	if value:
		return StringJDT.new("true")
	return StringJDT.new("false")

func inverse() -> BooleanJDT:
	if value:
		return BooleanJDT.new(false)
	return BooleanJDT.new(true)

func equals(other: JavaDataType) -> BooleanJDT:
	if other.classe != classe:
		return BooleanJDT.new(false)
	return BooleanJDT.new(value == other.value)
