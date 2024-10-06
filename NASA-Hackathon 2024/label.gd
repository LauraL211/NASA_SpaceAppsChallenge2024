extends CSGBox3D

# Called when the node enters the scene tree for the first time.
var star = load("res://star.tscn")
var rng = RandomNumberGenerator.new()
var exoplanet = rng.randi_range(0, 44)
func _init() -> void:
	var file = FileAccess.open("res://unmatchedpowerofthesuns.json", FileAccess.READ)
	var content = file.get_as_text()
	#content = content.substr(1, content.length() - 2)
	var json = JSON.new()
	var finish = json.parse(content)
	
	var x1 = int(json.data[exoplanet / 5]["exoplanets"][str(exoplanet)]["x"])
	var y1 = int(json.data[exoplanet / 5]["exoplanets"][str(exoplanet)]["y"])
	var z1 = int(json.data[exoplanet / 5]["exoplanets"][str(exoplanet)]["z"])
	
	#for i in range(0,8):
	#	for j in range(0, 5):
	for k in range(0,5071):
		var x2 = int(json.data[exoplanet / 5]["exoplanets"][str(exoplanet)]["stars"][str(k)]["x"])
		var y2 = int(json.data[exoplanet / 5]["exoplanets"][str(exoplanet)]["stars"][str(k)]["y"])
		var z2 = int(json.data[exoplanet / 5]["exoplanets"][str(exoplanet)]["stars"][str(k)]["z"])
		var instance = star.instantiate()
		var x3 = (x2 - x1)
		var y3 = (y2 - y1)
		var z3 = (z2 - z1)
		if(absf(x3) < 100.0 || absf(z3) < 100.0 || absf(y3) < 100.0):
			x3 = x3 * 50.0
			z3 = z3 * 50.0
			y3 = y3 * 50.0
			instance.scale = Vector3(instance.scale.x * 50.0, instance.scale.y * 50.0, instance.scale.z * 50.0)
		instance.transform.origin = Vector3(x3, y3, z3)
		add_child(instance)
		#print(json.data[i]["exoplanets"][str(i*5+j)]["stars"][str(k)])
