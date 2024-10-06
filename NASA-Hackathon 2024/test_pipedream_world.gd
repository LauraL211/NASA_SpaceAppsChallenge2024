extends Node3D



var interface : XRInterface
var scene2 
var mesh2
func _ready() -> void:
	interface = XRServer.find_interface("OpenXR")
	print("THIS IS A TEST")
	if interface and interface.is_initialized():
		print("Oh yes daddy")
		get_viewport().use_xr = true
		
	var scene = load("res://meshTest.tscn")
	var mesh = scene.instantiate()
	mesh.transform.origin = Vector3(0.0, 0.0, -5.0)
	scene2 = scene
	mesh2 = mesh
	add_child(mesh)
	print("scene loaded")


var counter = -5.0
var keepMoving = true

func _physics_process(delta: float) -> void:
	#print("called")
	mesh2.transform.origin = Vector3(0.0,0.0,counter)
	if keepMoving == true:
		counter = counter-2
	#print(counter)
	
#	print("called")
#	print (counter)
#	print(scene2)
#	var mesh = scene2.instantiate()
#	if counter % 10 == 0:
#		mesh.transform.origin = Vector3(counter / 10, counter/10, -5.0)
#		add_child(mesh)
#		print("inside if")
#	counter = counter + 1

func _input(event: InputEvent) -> void:
	#print(event.as_text())
	if event.as_text() == "Space":
		print("space pressed")
		keepMoving = false
		print(counter)
		print(keepMoving)

	
