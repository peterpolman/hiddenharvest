enum TileType { SEA, WATER, BEACH, SAND, GROUND, DIRT, GRASS, FOREST, FLOOR, ROCK, STONE, CULTIVATED }
enum State { IDLE, WALKING, SELECTING_ITEM, SELECTING_TILE }
enum ItemType { MUSHROOM_RED, MUSHROOM_BLUE_DOUBLE, MUSHROOM_BLUE_SINGLE, MUSHROOM_BLUE_SINGLE_BIG }
enum TileBorder {  North, East, South, West }
enum TileTransform {
	Rotate0 = 0, 
	Rotate90 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H, 
	Rotate180 = TileSetAtlasSource.TRANSFORM_FLIP_V | TileSetAtlasSource.TRANSFORM_FLIP_H, 
	Rotate270 = TileSetAtlasSource.TRANSFORM_FLIP_V | TileSetAtlasSource.TRANSFORM_TRANSPOSE
}
