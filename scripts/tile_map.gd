extends TileMap

var TILES = {
	"Grass": {"id": 3, "size": [3,2]},
	"Shore": {"id": 4, "size": [5,1]},
	"WinterTrees": {"id": 2, "size": [4,4]},
	"Trees": {"id": 5, "size": [4,1]},
	"Snow": {"id": 6, "size": [8,1]}
}
@export var TYPE = FastNoiseLite.TYPE_SIMPLEX
@export var HEIGHT = 200
@export var WIDTH = 200
@export var OCEAN_CUTOFFS = [0.3, 0.35, 0.4, 0.45, 0.5]
@export var MOUNTAIN_CUTOFFS = [0.8, 0.95]
@export var EDGE_CUTOFF = 20
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func deteriorate(x1, x2, cutoff):
	var dist = cutoff - abs(x1 - x2)
	var a = 1/(pow(cutoff, 2))
	return -a * pow(dist, 2)

func base_deteriorate(x1,x2, cutoff):
	return (abs(x1-x2)-cutoff) * 1.0/cutoff

func subtract_borders(x,y, cutoff):
	var subdivisions = 0.5/cutoff
	var to_subtract = 0.0
	if x < cutoff:
		to_subtract += deteriorate(x, 0, cutoff)
	if y < cutoff:
		to_subtract += deteriorate(y, 0, cutoff)
	if abs(x-WIDTH) < cutoff:
		to_subtract += deteriorate(x, WIDTH, cutoff)
	if abs(y-HEIGHT) < cutoff:
		to_subtract += deteriorate(y, HEIGHT, cutoff)
	return to_subtract

func _ready():
	rng.randomize()
	var heightmap = FastNoiseLite.new()
	heightmap.seed = rng.randf_range(0.0, 99999.0)
	heightmap.noise_type = TYPE
	
	var heights = []
	var min_height = 1.0
	var max_height = 0.0
	for x in HEIGHT:
		heights.append([])
		for y in WIDTH:
			heights[x].append(heightmap.get_noise_2d(x,y) * 0.5 + 0.5)
		var ma = heights[x].max()
		var mi = heights[x].min()
		if mi < min_height:
			min_height = mi
		if ma > max_height:
			max_height = ma
	var height_diff = max_height - min_height

	var tile = TILES["Grass"]
	var subtile = Vector2i(0,0)
	for x in HEIGHT:
		for y in WIDTH:
			var h = heights[x][y]
			h = h + subtract_borders(x,y, EDGE_CUTOFF)
			if h < OCEAN_CUTOFFS[0] * height_diff:
				tile = TILES["Shore"]
				subtile = Vector2i(4,0)
			elif h < OCEAN_CUTOFFS[1] * height_diff:
				tile = TILES["Shore"]
				subtile = Vector2i(3,0)
			elif h < OCEAN_CUTOFFS[2] * height_diff:
				tile = TILES["Shore"]
				subtile = Vector2i(2,0)
			elif h < OCEAN_CUTOFFS[3] * height_diff:
				tile = TILES["Shore"]
				subtile = Vector2i(1,0)
			elif h < OCEAN_CUTOFFS[4] * height_diff:
				tile = TILES["Shore"]
				subtile = Vector2i(0,0)
			elif h > MOUNTAIN_CUTOFFS[1] * height_diff:
				tile = TILES["Snow"]
				subtile = Vector2i(4, 0)
			elif h > MOUNTAIN_CUTOFFS[0] * height_diff:
				tile = TILES["Snow"]
				subtile = Vector2i(5, 0)
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
		print("Mouse Click at: ", event.position)
