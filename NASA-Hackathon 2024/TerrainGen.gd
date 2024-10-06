@tool
extends MeshInstance3D

var mat1 = preload("res://orange.tres")
var mat2 = preload("res://white.tres")

@export_range(20,400,1) var Terrain_Size := 100
@export_range(1,100,1) var resolution := 30

const center_offset := 0.5

@export var terrainHeight = 5
@export var noiseOffsetX = 0.0
@export var noiseOffsetZ = 0.0
@export var update = false
@export var clear_vert_vis = false

var min_height = 0
var max_height = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var array = [mat1, mat2]
	set_surface_override_material(0, array[0])
	generate_terrain()

func generate_terrain():
	var a_mesh: ArrayMesh
	var surftool = SurfaceTool.new()
	var n = FastNoiseLite.new()
	n.noise_type = FastNoiseLite.TYPE_PERLIN
	n.frequency = 0.1
	surftool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for z in resolution+1:
		for x in resolution+1:
			var percent = Vector2(x,z)/resolution
			var pointOnMesh = Vector3(percent.x, 0.0, percent.y)
			var vertex = pointOnMesh * Terrain_Size
			
			

			vertex.y = n.get_noise_2d(vertex.x, vertex.z)
			var uv = Vector2()
			uv.x = percent.x
			uv.y = percent.y
			surftool.set_uv(uv)
			surftool.add_vertex(vertex)

	var vert = 0
	for z in resolution:
		for x in resolution:
			surftool.add_index(vert + 0)
			surftool.add_index(vert + 1)
			surftool.add_index(vert + resolution + 1)
			surftool.add_index(vert + resolution + 1)
			surftool.add_index(vert + 1)
			surftool.add_index(vert + resolution + 2)
			vert += 1
		vert += 1
	
	surftool.generate_normals()
	a_mesh = surftool.commit()
	
	mesh = a_mesh

func draw_sphere(pos:Vector3):
	var ins = MeshInstance3D.new()
	add_child(ins)
	ins.position = pos
	var sphere = SphereMesh.new()
	sphere.radius = 0.1
	sphere.height = 0.2
	ins.mesh = sphere

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if update:
		generate_terrain()
		update = false
	if clear_vert_vis:
		for i in get_children():
			i.free()
