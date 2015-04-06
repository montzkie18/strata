package village.tiles
{
	import flash.geom.Point;

	public class TileIndexMap
	{
		private var _tiles : Vector.<TileIndex>;
		public function get tiles():Vector.<TileIndex> {return _tiles;}
		
		private var _bottomTile : Tile;
		public function get mainTile():Tile {return _bottomTile;}
		
		private var _centerY : int;
		public function get centerY():int {return _centerY;}
		
		private var _totalRow : int;
		public function get totalRow():int {return _totalRow;}
		
		private var _totalCol : int;
		public function get totalCol():int {return _totalCol;}
		
		public function TileIndexMap(mainTile:Tile, upperTile:Tile,
									 rowCount:int, colCount:int) {	
			_bottomTile = mainTile;
			_totalRow = rowCount;
			_totalCol = colCount;
			
			_centerY = upperTile.top.y + (
									(mainTile.bottom.y - upperTile.top.y)/2);
			
			_tiles = new Vector.<TileIndex>();
			
			//Store every tiles occupied
			for (var i:int = 0; i < rowCount; i++) {
				for (var j:int = 0; j < colCount; j++) {
					_tiles.push(new TileIndex(mainTile.row - i, mainTile.col - j));
				}
			}	
		}
	}
}