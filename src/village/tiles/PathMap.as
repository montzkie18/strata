package village.tiles
{
	import common.Utils;
	
	public class PathMap
	{
		// Contains a grid map of all path data
		private var _dataMap:Array;
		
		// [Read-Only] Number of rows in the map
		private var _rowCount:int;
		public function get rowCount():int { return _rowCount; };
		
		// [Read-Only] Number of columns in the map
		private var _colCount:int;
		public function get colCount():int { return _colCount; };
		
		public function PathMap()
		{
			_dataMap = new Array();
			_rowCount = 0;
			_colCount = 0;
		}
		
		public function destroy():void
		{
			Utils.clearArray(_dataMap);
			_dataMap = null;
		}
		
		public function setMapSize(row:int, col:int):void
		{
			if(row < _rowCount) removeRow(_rowCount - row);
			if(col < _colCount) removeColumn(_colCount - col);
			
			if(col > _colCount) addNewColumn(col - _colCount);
			if(row > _rowCount) addNewRow(row - _rowCount);
		}
		
		public function resetAllData():void
		{
			var row:Array;
			var data:TileData;
			var rowIndex:uint = 0;
			var colIndex:uint = 0;
			for each(row in _dataMap)
			{
				colIndex = 0;
				for each(data in row)
				{
					data.resetPathData();
					data.tileIndex.setNewIndex(rowIndex, colIndex);
					colIndex++;
				}
				rowIndex++;
			}
		}
		
		public function getData(index:TileIndex):TileData
		{
			return getDataAt(index.row, index.col);
		}
		
		public function getDataAt(row:int, col:int):TileData
		{
			if(_rowCount > row && _colCount > col){
				return _dataMap[row][col];
			}else{
				trace("[PathMap] Data in row: " + row + " col: " + col + " does not exist.");
				return null;
			}
		}
		
		private function addNewColumn(numToAdd:int = 1):void
		{
			//trace("Adding new column " + numToAdd);
			
			//! Automatically add a new row when datamap is empty.
			if(_dataMap.length == 0) {
				_dataMap.push(new Array());
				_rowCount++;
			}
			
			var row:Array;
			var tdata:TileData;
			var rowIndex:int = 0;
			for each(row in _dataMap){
				tdata = new TileData();
				tdata.tileIndex.setNewIndex(rowIndex, _colCount);
				row.push(tdata);
				rowIndex ++;
			}
			
			_colCount++;
			if(--numToAdd > 0) addNewColumn(numToAdd);
		}
		
		private function addNewRow(numToAdd:int = 1):void
		{
			//trace("Adding new row " + numToAdd);
			var newRow:Array = new Array();
			
			var tdata:TileData;
			var colIndex:int = 0;
			do{
				tdata = new TileData();
				tdata.tileIndex.setNewIndex(_rowCount, colIndex);
				newRow.push(tdata);
				colIndex ++;
			}while(newRow.length < _colCount);
			
			_rowCount++;
			_dataMap.push(newRow);
			if(--numToAdd > 0) addNewRow(numToAdd);
		}
		
		private function removeColumn(numToRemove:int = 1):void
		{
			var row:Array;
			for each(row in _dataMap)
			{
				row.pop();
			}
			if(_colCount > 0) _colCount--;
			if(--numToRemove > 0) removeColumn(numToRemove);
		}
		
		private function removeRow(numToRemove:int = 1):void
		{
			var row:Array = _dataMap.pop();
			Utils.clearArray(row);
			row = null;
			if(_rowCount > 0) _rowCount--;
			if(--numToRemove > 0) removeRow(numToRemove);
		}

	}
}