extends Node

@onready var turn_manager: TurnManager = TurnManager.new()
@onready var game_map: GameMap = GameMap.new()

func _ready() -> void:
	add_child(turn_manager)
	add_child(game_map)

	# Charge les données (JSON) puis init
	var data := DataLoader.load_all()
	game_map.build_from_data(data.regions, data.countries)
	turn_manager.init(game_map.get_countries())

	# Démo : spawn 2 unités
	var france := game_map.get_country("FRA")
	var germany := game_map.get_country("GER")

	game_map.spawn_unit(france, "infantry", "paris")
	game_map.spawn_unit(germany, "tank", "berlin")

	print("Game ready. Current player:", turn_manager.current_country.tag)

func _process(_delta: float) -> void:
	# Debug clavier: N = fin de tour
	if Input.is_action_just_pressed("ui_accept"):
		turn_manager.end_turn(game_map)
