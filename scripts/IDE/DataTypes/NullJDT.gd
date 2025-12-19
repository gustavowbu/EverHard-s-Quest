extends JavaDataType
class_name NullJDT

func _init() -> void:
	classe = "null"

func toString() -> StringJDT:
	return StringJDT.new("null");

func equals(other: JavaDataType) -> BooleanJDT:
	if other.classe != classe:
		return BooleanJDT.new(false)
	return BooleanJDT.new(true)
