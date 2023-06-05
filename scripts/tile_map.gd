extends TileMap

var TILES = {
	"Grass": {"id": 3, "size": [3,2]},
	"Shore": {"id": 4, "size": [5,1]},
	"WinterTrees": {"id": 2, "size": [4,4]},
	"Trees": {"id": 5, "size": [4,1]},
	"Snow": {"id": 6, "size": [8,1]}
}
@export var TYPE = FastNoiseLite.TYPE_SIMPLEX
@export var HEIGHT = 500
@export var WIDTH = 500
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func subtract_borders(x,y, cutoff):
	var subdivisions = 1.0/cutoff
	if x == 0:
		return -1
	if y == 0:
		return -1
	if x < cutoff:
		return (x-cutoff)*subdivisions
	if y < cutoff:
		return (y-cutoff)*subdivisions
#	if WIDTH - x < cutoff:
#		return -log(WIDTH-x)
#	if HEIGHT - y < cutoff:
#		return -log(HEIGHT-y)
	return 0

func _ready():
	rng.randomize()
	var heightmap = FastNoiseLite.new()
	heightmap.seed = rng.randf_range(0.0, 99999.0)
	heightmap.noise_type = TYPE
	

	var tile = TILES["Grass"]
	var subtile = Vector2i(0,0)
	for x in HEIGHT:
		for y in WIDTH:
			var h = heightmap.get_noise_2d(x,y) * 0.5 + 0.5
			h = h + subtract_borders(x,y, 40)
			if h < 0.3:
				tile = TILES["Shore"]
				subtile = Vector2i(4,0)
			elif h < 0.35:
				tile = TILES["Shore"]
				subtile = Vector2i(3,0)
			elif h < 0.4:
				tile = TILES["Shore"]
				subtile = Vector2i(2,0)
			elif h < 0.45:
				tile = TILES["Shore"]
				subtile = Vector2i(1,0)
			elif h < 0.5:
				tile = TILES["Shore"]
				subtile = Vector2i(0,0)
			else:
				tile = TILES["Grass"]
				subtile = Vector2i(rng.randi_range(0, tile["size"][0] - 1), rng.randi_range(0, tile["size"][1] - 1))
			set_cell(0, Vector2i(x,y), tile["id"], subtile)
#			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	
	if event is InputEventMouseButton:
		var pos = get_viewport().get_mouse_position()
		print(map_to_local(pos))
		print(local_to_map(pos))
		var tile_loc = local_to_map(pos)
		set_cell(0, tile_loc, 3, Vector2i(1,1))
		print("Mous Click at: ", event.position)
