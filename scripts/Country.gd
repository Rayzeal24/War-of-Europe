extends RefCounted
class_name Country

var tag: String
var name: String

var money: int = 100
var industry: int = 10

var regions: Array[Region] = []
var units: Array[Unit] = []

func _init(_tag: String, _name: String) -> void:
	tag = _tag
	name = _name

func on_turn_end() -> void:
	# Économie simple: income = nb régions + industrie
	var income := regions.size() + industry
	money += income

	# Refresh unités du pays
	for u in units:
		u.move_points = u.move_points_max
