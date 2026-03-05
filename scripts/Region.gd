extends RefCounted
class_name Region

var id: String
var name: String

var owner_tag: String = ""
var owner: Country = null
var neighbors: Array = []  # Array[String]

func _init(_id: String, _name: String) -> void:
	id = _id
	name = _name
