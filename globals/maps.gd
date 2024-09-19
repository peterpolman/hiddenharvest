
const item_map = {
	Enums.ItemType.MUSHROOM_BLUE_SINGLE: preload("res://resources/inventory/items/mushrooms_blue_single.tres"),
	Enums.ItemType.MUSHROOM_BLUE_SINGLE_BIG: preload("res://resources/inventory/items/mushrooms_blue_single_big.tres"),
	Enums.ItemType.MUSHROOM_BLUE_DOUBLE: preload("res://resources/inventory/items/mushrooms_blue_double.tres"),
	Enums.ItemType.MUSHROOM_RED: preload("res://resources/inventory/items/mushroom.tres")
}

const tile_type_map = {
	Enums.TileType.SEA: {
		"default": [0,0],
		"random": [],
		"borders": [],
		"details": []
	},
	Enums.TileType.WATER: {
		"default": [0,1],
		"random": [],
		"borders": [],
		"details": []
	},
	Enums.TileType.BEACH: {
		"default": [0,2],
		"random":[],
		"borders": [],
		"details": []
	},
	Enums.TileType.SAND: {
		"default": [0,3],
		"random":[],
		"borders": [],
		"details": []
	},
	Enums.TileType.GROUND: {
		"default": [0,4],
		"random":[[4,4],[5,4],[6,4],[7,4],[8,4]],
		"borders": [[1,4],[2,4],[3,4]],
		"details": [[0,11],[1,11],[2,11],[3,11],[4,12]]
	},
	Enums.TileType.DIRT: {
		"default": [0,5],
		"random":[],
		"borders": [[1,5],[2,5],[3,5]],
		"details": [[0,11],[1,11],[2,11],[3,11]]
	},
	Enums.TileType.GRASS: {
		"default": [0,6],
		"random":[[4,6],[5,6],[6,6],[7,6],[8,6],[9,6]],
		"borders": [[1,6],[2,6],[3,6]],
		"details": [[0,12],[1,12],[2,12],[3,12],[0,13],[1,13],[2,13],[3,13],[0,14],[1,14],[2,14],[3,14]]
	},
	Enums.TileType.FOREST: {
		"default": [0,7],
		"random":[[4,7],[5,7],[6,7],[7,7],[8,7],[9,7]],
		"borders": [[1,7],[2,7],[3,7]],
		"details": [[4,11],[4,13]]
	},
	Enums.TileType.FLOOR: {
		"default": [0,8],
		"random":[],
		"borders": [[8,8],[4,8],[6,8],[1,8],[3,8],[2,8],[7,8],[5,8]],
		"details": []
	},
	Enums.TileType.ROCK: {
		"default": [0,9],
		"random":[],
		"borders": [],
		"details": []
	},
	Enums.TileType.STONE: {
		"default": [0,10],
		"random":[],
		"borders": [],
		"details": []
	},
	Enums.TileType.CULTIVATED: {
		"default": [1,15],
		"random":[],
		"borders": [],
		"details": []
	}
}

const border_directions = {
	Enums.TileBorder.North: Vector2(0, -1), 
	Enums.TileBorder.East: Vector2(1, 0),
	Enums.TileBorder.South: Vector2(0, 1), 
	Enums.TileBorder.West: Vector2(-1, 0) 
}

const border_map = {
	1: {
		"0": Enums.TileTransform.Rotate0,
		"1": Enums.TileTransform.Rotate90,
		"2": Enums.TileTransform.Rotate180,
		"3": Enums.TileTransform.Rotate270
	},
	2: {
		"01": Enums.TileTransform.Rotate0,
		"12": Enums.TileTransform.Rotate90,
		"23": Enums.TileTransform.Rotate180,
		"03": Enums.TileTransform.Rotate270,
		"13": Enums.TileTransform.Rotate0, # Occurs but does not exist in sprite
	}
}

const tile_wall_border_index_map = {
	"0": 0,
	"01": 1,
	"1": 2,
	"12": 3,
	"13": 2,
	"0123": 2,
	"2": 4,
	"23": 5,
	"3": 6,
	"30": 7,
	"03": 7,
}
