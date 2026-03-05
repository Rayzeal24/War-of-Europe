extends Node
class_name DataLoader

class LoadedData:
	var regions: Array = []
	var countries: Array = []
	var units: Dictionary = {}

static func load_json(path: String) -> Variant:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_error("Cannot open: " + path)
		return null
	var txt := f.get_as_text()
	var parsed := JSON.parse_string(txt)
	if parsed == null:
		push_error("Invalid JSON: " + path)
	return parsed

static func load_all() -> LoadedData:
	var out := LoadedData.new()
	out.regions = load_json("res://data/regions.json")
	out.countries = load_json("res://data/countries.json")
	out.units = load_json("res://data/units.json")
	return out
