package village.tiles
{
	import flash.events.Event;
	
	
	public class PathFinder
	{
		private static var _instance:PathFinder;
		
		private static const ADJACENT_VALUE:uint = 10;
		private static const DIAGONAL_VALUE:uint = 14;
		
		private var _startIndex:TileIndex;
		private var _goalIndex:TileIndex;

		private var _dataMap:PathMap;
		private var _aOpenList:Array;
		
		private var _maxRow:uint;
		private var _maxCol:uint;
		
		private var _grid:TileGrid;
		
		public function PathFinder(grid:TileGrid)
		{
			_grid = grid;
			
			setMapSize(_grid.getRowCount(), _grid.getColumnCount());
			
			_grid.addEventListener(TileGrid.SIZE_CHANGED, onTilegridSizeChanged, false, 0, true);
		}
		
		public function destroy():void 
		{
			_grid.removeEventListener(TileGrid.SIZE_CHANGED, onTilegridSizeChanged, false);
			
			_startIndex = null;
			_goalIndex = null;
			
			_dataMap.destroy();
			_dataMap = null;
			
			_aOpenList = null;
		}
		
		private function onTilegridSizeChanged(event:Event):void
		{
			setMapSize(_grid.getRowCount(), _grid.getColumnCount());
		}
		
		private function setMapSize(row:int, col:int):void
		{
			if(_dataMap == null)
				_dataMap = new PathMap();
			
			_dataMap.setMapSize(row, col);
		}
		
		public function getTileData(tileIndex:TileIndex):TileData
		{
			return _dataMap.getData(tileIndex);
		}
		
		public function getTileDataAt(row:int, col:int):TileData
		{
			return _dataMap.getDataAt(row, col);
		}
		
		public function findPath(startXY:TileIndex, goalXY:TileIndex):Array
		{
			if( startXY == null || goalXY == null) return null;
			_startIndex = startXY;
			_goalIndex = goalXY;
		
			_aOpenList = new Array();
			
			_maxRow = _dataMap.rowCount;
			_maxCol = _dataMap.colCount;
			
			_dataMap.resetAllData();
					
			var currentTile:TileData = getTileData(_startIndex);
			currentTile.parentIndex.setNewIndex(_startIndex.row, _startIndex.col);
			currentTile.bIsOnOpenList = true;
			_aOpenList.push(currentTile);
			
			
			var bResult:Boolean = false;
			bResult = searchPath(_startIndex);
			
			if(bResult){
				return getResultPath();
			}else{
				return null
			}
		}
		
		private function searchPath(currentTileIndex:TileIndex):Boolean
		{
			// get neighbors.
			var aNeighbors:Array = getNeighborIndexes(currentTileIndex);
			
			// calculate values for neighbors. ignore blockers/non-walkables and those that were closed.
			var i:int = 0;
			var aNeighborsLength:int = aNeighbors.length;
			var tmpIdx:TileIndex;
			var tmpTile:TileData;
			var tmpCostG:Number;
			
			for(i = 0; i < aNeighborsLength; i++)
			{
				tmpIdx = aNeighbors[i];
				tmpTile = getTileData(tmpIdx);
				
				if(tmpTile.bIsWalkable && !tmpTile.bIsOnClosedList)
				{
					if(tmpTile.bIsOnOpenList)
					{
						//check to see if this path to that square is better
						tmpCostG = calculateCostG(tmpTile);
						
						if(tmpCostG < tmpTile.nCostG)
						{
							//save current tile as parent.
							tmpTile.parentIndex.setNewIndex(currentTileIndex.row, currentTileIndex.col);
							tmpTile.nCostG = calculateCostG(tmpTile);
							tmpTile.nCostH = calculateCostH(tmpTile);
							tmpTile.nCostF = tmpTile.nCostG + tmpTile.nCostH;
						}
					}
					else
					{
						//save current tile as parent.
						tmpTile.parentIndex.setNewIndex(currentTileIndex.row, currentTileIndex.col);
						tmpTile.nCostG = calculateCostG(tmpTile);
						tmpTile.nCostH = calculateCostH(tmpTile);						
						tmpTile.nCostF = tmpTile.nCostG + tmpTile.nCostH;
						
						// add to openlist as well
						tmpTile.bIsOnOpenList = true;
						_aOpenList.push(tmpTile.tileIndex);
					}
				}
			}
			
			getTileData(currentTileIndex).bIsOnClosedList = true;
			
			// if current tile is the goal, add to close list and stop.
			if(currentTileIndex.col == _goalIndex.col && currentTileIndex.row == _goalIndex.row)
			{
				return true;
			}
			
			// if openlist is empty, stop
			if(isOpenListEmpty())
			{
				// no path found.
				return false;
			}
			
			// select the tile with the lowest CostF
			return searchPath(getLowestCostF());
		}
		
		//! returns an array of indexes of the current tile's neighbor
		private function getNeighborIndexes(tileIndex:TileIndex):Array
		{
			var aNeighbors:Array = new Array();

			// upper left
//			if(tileIndex.col - 1 >= 0 && tileIndex.row - 1 >= 0)
//			{
//				aNeighbors.push(new CTileIndex(tileIndex.row - 1, tileIndex.col - 1));
//			}
			
			// up
			if(tileIndex.row - 1 >= 0)
			{
				aNeighbors.push(new TileIndex(tileIndex.row-1, tileIndex.col));
			}
			
			// upper right
//			if(tileIndex.row - 1 >= 0 && tileIndex.col + 1 < _maxCol)
//			{
//				aNeighbors.push(new CTileIndex(tileIndex.row - 1, tileIndex.col + 1));
//			}
			
			// left
			if(tileIndex.col - 1 >= 0)
			{
				aNeighbors.push(new TileIndex(tileIndex.row, tileIndex.col-1));
			}
			
			// right
			if(tileIndex.col + 1 < _maxCol)
			{
				aNeighbors.push(new TileIndex(tileIndex.row, tileIndex.col+1));
			}
			
			// lower left
//			if(tileIndex.col - 1 >= 0 && tileIndex.row + 1 < _maxRow)
//			{
//				aNeighbors.push(new CTileIndex(tileIndex.row + 1, tileIndex.col - 1));
//			}
			
			// down
			if(tileIndex.col >= 0 && tileIndex.row + 1 < _maxRow)
			{
				aNeighbors.push(new TileIndex(tileIndex.row+1, tileIndex.col));
			}
			
			// lower right
//			if(tileIndex.col + 1 < _maxCol && tileIndex.row + 1 < _maxRow)
//			{
//				aNeighbors.push(new CTileIndex(tileIndex.row +1, tileIndex.col + 1));
//			}
			
			return aNeighbors;	
		}
		
		private function calculateCostG(tile:TileData):Number
		{
			if(((tile.tileIndex.col > tile.parentIndex.col) || (tile.tileIndex.col < tile.parentIndex.col))
				&& ((tile.tileIndex.row > tile.parentIndex.row) || (tile.tileIndex.row < tile.parentIndex.row)))
			{
				//tile.nCostG = ADJACENT_VALUE;
				return getTileData(tile.parentIndex).nCostG + DIAGONAL_VALUE;
			}
			else
			{
				return getTileData(tile.parentIndex).nCostG + ADJACENT_VALUE;
			}
		}
		
		
		private function calculateCostH(tile:TileData):Number
		{
			var nCostH:Number = 0;
			
			nCostH = nCostH + (Math.abs(tile.tileIndex.col - getTileData(_goalIndex).tileIndex.col) * ADJACENT_VALUE);
			nCostH = nCostH + (Math.abs(tile.tileIndex.row - getTileData(_goalIndex).tileIndex.row) * ADJACENT_VALUE);
			
			return nCostH;
		}
		
		private function getLowestCostF():TileIndex
		{
			var i:uint = 0;
			var tmpTile:TileData;
			var tmpIdx:TileIndex;
			
			var lowestCostF:Number = 0;
			var nIndex:int = -1;
			var aOpenListLength:uint = _aOpenList.length;
			for(i = 0; i < aOpenListLength; i++)
			{
				tmpIdx = _aOpenList[i];
				tmpTile = getTileData(tmpIdx);
				
				if((tmpTile.bIsOnClosedList == false && tmpTile.nCostF < lowestCostF)
					|| (lowestCostF == 0 && tmpTile.bIsOnClosedList == false))
				{
					lowestCostF = tmpTile.nCostF;
					nIndex = i;
				}
			}
			
			
			if(nIndex >= 0)
			{
				return _aOpenList[nIndex];
			}
			
			
			return new TileIndex(-1, -1);
		}
		
		private function getResultPath():Array
		{
			var aPath:Array = new Array();
			var bContinue:Boolean = true;
			var currentTile:TileData = getTileData(_goalIndex);
			
			while(bContinue)
			{
				aPath.push(currentTile.tileIndex);
				
				currentTile = getTileData(currentTile.parentIndex);
				
				if(currentTile.tileIndex.col == _startIndex.col && currentTile.tileIndex.row == _startIndex.row)
				{
					bContinue = false;
				}
			}
			
			return aPath;
			
		}
		
		private function isOpenListEmpty():Boolean
		{
			var bResult:Boolean = true;
			
			var i:uint = 0;
			var tmpTile:TileData;
			var tmpIdx:TileIndex;
			
			// xtian -debug
			var aOpenListLength:uint = _aOpenList.length;
			for(i = 0; i < aOpenListLength; i++)
			{
				tmpIdx = _aOpenList[i];
				tmpTile = getTileData(tmpIdx);
				
				if(tmpTile.bIsOnClosedList == false)
				{
					return false;
				}
			}
			
			return true;
		}
	}
}