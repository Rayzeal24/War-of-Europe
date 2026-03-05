extends Node
class_name GameMap

var regions: Dictionary = {}        # id -> Region
var countries_by_tag: Dictionary = {} # tag -> Country
var units: Array[Unit] = []

var unit_defs: Dictionary = {}

func build_from_data(regions_data: Array, countries_data: Array) -> void:
	# Countries
	for c in countries_data:
		var country := Country.new(c.tag, c.name)
		country.money = int(c.get("money", 100))
		country.industry = int(c.get("industry", 10))
		countries_by_tag[country.tag] = country

	# Regions
	for r in regions_data:
		var region := Region.new(r.id, r.name)
		region.owner_tag = r.owner
		region.neighbors = r.neighbors
		regions[region.id] = region

	# Assoc owners
	for region in regions.values():
		var owner := get_country(region.owner_tag)
		region.owner = owner
		owner.regions.append(region)

	# Charger unit defs
	unit_defs = DataLoader.load_json("res://data/units.json")

func get_country(tag: String) -> Country:
	return countries_by_tag.get(tag)

func get_countries() -> Array[Country]:
	var arr: Array[Country] = []
	for c in countries_by_tag.values():
		arr.append(c)
	arr.sort_custom(func(a,b): return a.tag < b.tag)
	return arr

func get_region(id: String) -> Region:
	return regions.get(id)

func spawn_unit(country: Country, unit_type: String, region_id: String) -> Unit:
	var region := get_region(region_id)
	if region == null:
		push_error("Unknown region: " + region_id)
		return null

	var def := unit_defs.get(unit_type)
	if def == null:
		push_error("Unknown unit type: " + unit_type)
		return null

	var u := Unit.new()
	u.owner = country
	u.unit_type = unit_type
	u.hp = int(def.hp)
	u.atk = int(def.atk)
	u.defense = int(def.def)
	u.move_points_max = int(def.mp)
	u.move_points = u.move_points_max
	u.region = region

	units.append(u)
	country.units.append(u)
	return u

func can_move(unit: Unit, to_region_id: String) -> bool:
	var to_r := get_region(to_region_id)
	if to_r == null: return false
	if unit.move_points <= 0: return false
	return unit.region.neighbors.has(to_r.id)

func move_unit(unit: Unit, to_region_id: String) -> void:
	if not can_move(unit, to_region_id):
		return
	unit.region = get_region(to_region_id)
	unit.move_points -= 1

func attack(attacker: Unit, target: Unit) -> void:
	# Modèle ultra simple (à améliorer)
	if attacker.move_points <= 0:
		return
	if attacker.region.id != target.region.id and not attacker.region.neighbors.has(target.region.id):
		return

	var damage_to_target := max(1, attacker.atk - int(target.defense * 0.5))
	target.hp -= damage_to_target
	attacker.move_points = 0

	if target.hp <= 0:
		kill_unit(target)

func kill_unit(u: Unit) -> void:
	units.erase(u)
	if u.owner:
		u.owner.units.erase(u)

func on_global_turn() -> void:
	# Exemple: ravitaillement / attrition / etc.
	# Ici: refresh toutes les unités
	for u in units:
		u.move_points = u.move_points_max
