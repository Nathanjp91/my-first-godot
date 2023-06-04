extends TileMap

var TILES = {
	"Grass": {"id": 3, "size": [3,2]},
	"Shore": {"id": 4, "size": [5,1]},
	"WinterTrees": {"id": 2, "size": [4,4]},
	"Trees": {"id": 5, "size": [4,1]},
	"Snow": {"id": 6, "size": [8,1]}
}
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var forest = FastNoiseLite.new()
	forest.seed = rng.randf_range(0.0, 99999.0)
	forest.noise_type = FastNoiseLite.TYPE_PERLIN
	
	var biomes = FastNoiseLite.new()
	biomes.seed = rng.randf_range(0.0, 99999.0)
	biomes.noise_type = FastNoiseLite.TYPE_PERLIN
	
	for x in 100:
		for y in 50:
			var f = forest.get_noise_2d(x, y) * 0.5 + 0.5
			var b = biomes.get_noise_2d(x, y) * 0.5 + 0.5
			if b >= 0.5:
				var tile = TILES["Grass"]
				var subtile = Vector2i(rng.randi_range(0, tile["size"][0] - 1), rng.randi_range(0, tile["size"][1] - 1))
				set_cell(0, Vector2i(x, y), tile["id"], subtile)
				if f >= 0.5:
					tile = TILES["Trees"]
					subtile = Vector2i(rng.randi_range(0, tile["size"][0] - 1), rng.randi_range(0, tile["size"][1] - 1))
					set_cell(1, Vector2i(x, y), tile["id"], subtile)
					
			elif b >= 0.45:
				var tile = TILES["Snow"]
				var subtile = Vector2i(7, 0)
				set_cell(0, Vector2i(x, y), tile["id"], subtile)
				if f >= 0.5:
					tile = TILES["WinterTrees"]
					subtile = Vector2i(rng.randi_range(0, tile["size"][0] - 1), rng.randi_range(0, tile["size"][1] - 1))
					set_cell(1, Vector2i(x, y), tile["id"], subtile)
			elif b >= 0.40:
				var tile = TILES["Snow"]
				var subtile = Vector2i(6, 0)
				set_cell(0, Vector2i(x, y), tile["id"], subtile)
				if f >= 0.5:
					tile = TILES["WinterTrees"]
					subtile = Vector2i(rng.randi_range(0, tile["size"][0] - 1), rng.randi_range(0, tile["size"][1] - 1))
					set_cell(1, Vector2i(x, y), tile["id"], subtile)
			elif b >= 0.35:
				var tile = TILES["Snow"]
				var subtile = Vector2i(5, 0)
				set_cell(0, Vector2i(x, y), tile["id"], subtile)
				if f >= 0.5:
					tile = TILES["WinterTrees"]
					subtile = Vector2i(rng.randi_range(0, tile["size"][0] - 1), rng.randi_range(0, tile["size"][1] - 1))
					set_cell(1, Vector2i(x, y), tile["id"], subtile)
			else:
				var tile = TILES["Snow"]
				var subtile = Vector2i(4, 0)
				set_cell(0, Vector2i(x, y), tile["id"], subtile)
				if f >= 0.5:
					tile = TILES["WinterTrees"]
					subtile = Vector2i(rng.randi_range(0, tile["size"][0] - 1), rng.randi_range(0, tile["size"][1] - 1))
					set_cell(1, Vector2i(x, y), tile["id"], subtile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
