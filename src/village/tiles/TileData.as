package village.tiles
{
	
	public class TileData
	{
		//xtian - variables for path finding.
		public var bIsOnClosedList:Boolean;
		public var bIsOnOpenList:Boolean;
		public var bIsWalkable:Boolean;
		public var nCostF:Number;
		public var nCostH:Number;
		public var nCostG:Number;
		
		// [Read-Only]
		private var _parentIndex:TileIndex;
		public function get parentIndex():TileIndex { return _parentIndex; };
		
		// [Read-Only]
		private var _tileIndex:TileIndex;
		public function get tileIndex():TileIndex { return _tileIndex; };
		
		public function TileData()
		{
			_parentIndex = new TileIndex(-1,-1);
			_tileIndex = new TileIndex(-1,-1);
			
			bIsWalkable = true;
			
			resetPathData();
		}
		
		public function resetPathData():void
		{
			bIsOnClosedList = false;
			bIsOnOpenList = false;
			
			nCostF = 0;
			nCostH = 0;
			nCostG = 0;
			
			_parentIndex.setNewIndex(-1,-1);
		}
	}
}