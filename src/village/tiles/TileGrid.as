package village.tiles
{
	import common.Utils;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	public class TileGrid extends EventDispatcher
	{
		public static const SIZE_CHANGED:String = "sizechanged";
		
		private var _tileMap:Array;
		private var _type:GridType;
		
		private var _rowCount:int;
		private var _colCount:int;
		
		private var _targetNumRow:int;
		private var _targetNumCol:int;
		
		// Upper-left corner of the Grid
		private var _anchorPoint:Point;
		
		public function TileGrid(gridType:GridType, position:Point = null)
		{			
			_rowCount = 0;
			_colCount = 0;
			_targetNumRow = 0;
			_targetNumCol = 0;

			_type = gridType;
			
			if(position){
				position.x -= this.getWidth()/2;
			}
			_anchorPoint = (position == null) ? new Point(0,0) : position;			
		}
		
		private function initTileMap():void
		{
			if(_tileMap == null)
				_tileMap = new Array();
		}
		
		public function setGridSize(row:int, col:int):void
		{
			initTileMap();
			
			_targetNumRow = row;
			_targetNumCol = col;
			
			if(row < _rowCount) removeRow(_rowCount - row);
			if(col < _colCount) removeColumn(_colCount - col);
			
			if(col > _colCount) addColumn(col - _colCount);
			if(row > _rowCount) addRow(row - _rowCount);
			
			// inform listeners that we have changed size
			dispatchEvent(new Event(SIZE_CHANGED));
		}
		
		public function getTileAt(row:int, col:int):Tile
		{
			if(row >= 0 && col >= 0 && _rowCount > row && _colCount > col){
				return _tileMap[row][col];
			}else{
				trace("[TileGrid] Tile in row: " + row + " col: " + col + " does not exist.");
				return null;
			}
		}
		
		public function getTileAtIndex(tileIndex:TileIndex):Tile
		{
			return getTileAt(tileIndex.row, tileIndex.col);
		}
		
		public function getTileAtPoint(pt:Point):Tile
		{
			// Width and height of each tile
			var tw:Number = Tile.TILE_WIDTH;
			var th:Number = Tile.TILE_HEIGHT;
			// Upper left corner of the Grid 
			var ap:Point = _anchorPoint;
			// Index of target tile
			var row:int = 0;
			var col:int = 0;
			if(_type == GridType.ORTHOGRAPHIC)
			{
				col = (pt.x - ap.x) / tw;
				row = (pt.y - ap.y) / th;
				
				return getTileAt(row, col);
			}
			else if(_type == GridType.ISOMETRIC)
			{
				// Center point
				var cp:Point = new Point(ap.x + getWidth()/2, ap.y + getHeight()/2);
				var localX:Number = pt.x - cp.x;
				var localY:Number = pt.y - ap.y;
				var hw:Number = tw * 0.5;	// Half width
				var hh:Number = th * 0.5;	// Half height
				
				row = (localY / th) - (localX / tw);
				col = (localY / hh) - row;
				if(col >= _colCount) col = _colCount - 1;
				trace("Row: " + row + " Col: " + col);
				var tile:Tile = getTileAt(row, col);
				if(tile)
				{
					if(tile.hasPoint(pt, GridType.ISOMETRIC)){
						trace("Inside Tile");
						return tile;
					}
					
					var cx:Number = tile.screenPos.x + hw;
					var cy:Number = tile.screenPos.y + hh;
					if(pt.x < cx && pt.y < cy){
						return getTileAt(row, col-1);
					}
					else if(pt.x < cx && pt.y >= cy){
						return getTileAt(row+1, col);
					}
					else if(pt.x >= cx && pt.y < cy){
						return getTileAt(row-1, col);
					}
					else if(pt.x >= cx && pt.y >= cy){
						return getTileAt(row, col+1);
					}
				}
			}
			
			return null;
		}
		
		public function areTilesFree(tiles:TileIndexMap):Boolean
		{
			for (var i:int = 0; i < tiles.tiles.length; i++) {
				var tempTile:Tile = getTileAt(tiles.tiles[i].row, 
											  tiles.tiles[i].col);
				
				if (tempTile == null || tempTile.isOccupied)
					return false;
			}
			return true;
		}
		
		public function occupyTiles(tiles:TileIndexMap):void
		{
			for (var i:int = 0; i < tiles.tiles.length; i++){
				getTileAt(tiles.tiles[i].row, 
					tiles.tiles[i].col).isOccupied = true;
			}
		}
		
		public function freeTiles(tiles:TileIndexMap):void
		{
			for (var i:int = 0; i < tiles.tiles.length; i++){
				getTileAt(tiles.tiles[i].row, 
					tiles.tiles[i].col).isOccupied = false;
			}
		}
		
		public function getRowCount():int
		{
			return _rowCount;
		}
		
		public function getColumnCount():int
		{
			return _colCount;
		}
		
		private function addColumn(numToAdd:int = 1):void
		{
			//trace("Adding GRID new column " + numToAdd);
			
			//! Automatically add a new row when grid is empty.
			if(_tileMap.length == 0){
				_tileMap.push(new Array());
				_rowCount++;
			}
			
			var row:Array;
			var tile:Tile;
			var rowIndex:int = 0;
			for each(row in _tileMap){
				tile = new Tile(rowIndex, _colCount);
				setTilePosition(tile, rowIndex, _colCount);
				row.push(tile);
				rowIndex++;
			}
			
			_colCount++;
			if(--numToAdd > 0) addColumn(numToAdd);
		}
		
		private function addRow(numToAdd:int = 1):void
		{
			//trace("Adding GRID new row " + numToAdd);
			var newRow:Array = new Array();
			var tile:Tile;
			var colIndex:int = 0;
			do{
				tile = new Tile(_rowCount, colIndex);
				setTilePosition(tile, _rowCount, colIndex);
				newRow.push(tile);
				colIndex++;
			}while(newRow.length < _colCount);
			
			_rowCount++;
			_tileMap.push(newRow);
			if(--numToAdd > 0) addRow(numToAdd);
		}
		
		private function removeColumn(numToRemove:int = 1):void
		{
			var row:Array;
			var tile:Tile;
			for each(row in _tileMap)
			{
				tile = row.pop() as Tile;
				tile = null;
			}
			if(_colCount > 0) _colCount--;
			if(--numToRemove > 0) removeColumn(numToRemove);
		}
		
		private function removeRow(numToRemove:int = 1):void
		{
			var row:Array = _tileMap.pop();
			Utils.clearArray(row);
			row = null;
			if(_rowCount > 0) _rowCount--;
			if(--numToRemove > 0) removeRow(numToRemove);
		}
		
		private function setTilePosition(tile:Tile, row:int, col:int):void
		{
			var tileWidth:int = Tile.TILE_WIDTH;
			var tileHeight:int = Tile.TILE_HEIGHT;
			var tileX:Number;
			var tileY:Number;
			if(_type == GridType.ISOMETRIC)
			{
				var centerX:Number = _anchorPoint.x + getWidth()/2;
				var halfWidth:Number = tileWidth * 0.5;
				var halfHeight:Number = tileHeight * 0.5;
				tileX = centerX + halfWidth * (col - row - 1);
				tileY = _anchorPoint.y + halfHeight * (row + col);
			}
			else if(_type == GridType.ORTHOGRAPHIC)
			{
				tileX = _anchorPoint.x + tileWidth * col;
				tileY = _anchorPoint.y + tileHeight * row;
			}
			
			tile.screenPos = new Point(tileX, tileY);
		}
		
		private function getWidth():Number
		{
			var gridSize:Number;
			
			if(_type == GridType.ISOMETRIC)
			{
				gridSize = Math.max(_targetNumRow, _targetNumCol);
			}
			else if(_type == GridType.ORTHOGRAPHIC)
			{
				gridSize = _colCount;
			}
			
			return gridSize * Tile.TILE_WIDTH;
		}
		
		private function getHeight():Number
		{
			var gridSize:Number;
			
			if(_type == GridType.ISOMETRIC)
			{
				gridSize = Math.max(_targetNumRow, _targetNumCol);
			}
			else if(_type == GridType.ORTHOGRAPHIC)
			{
				gridSize = _rowCount;
			}
			
			return gridSize * Tile.TILE_HEIGHT;
		}
	}
}