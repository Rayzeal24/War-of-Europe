extends Node
class_name TurnManager

var countries: Array[Country] = []
var current_index: int = 0
var turn_number: int = 1

var current_country: Country:
	get:
		return countries[current_index]

func init(countries_list: Array[Country]) -> void:
	countries = countries_list
	current_index = 0
	turn_number = 1

func end_turn(game_map: GameMap) -> void:
	# Tick économie + refresh unités du joueur courant
	current_country.on_turn_end()

	# Passe au suivant
	current_index = (current_index + 1) % countries.size()

	# Nouveau tour global quand on revient au 1er
	if current_index == 0:
		turn_number += 1
		print("=== GLOBAL TURN", turn_number, "===")
		game_map.on_global_turn()

	print("Next player:", current_country.tag)
