package village.tiles
{
	public class TileIndex
	{
		// [Read-Only] 
		private var _row:int;
		public function get row():int { return _row; };
		
		// [Read-Only] 
		private var _col:int;
		public function get col():int { return _col; };
		
		public function TileIndex(row:int, col:int)
		{
			setNewIndex(row, col);
		}
		
		public function setNewIndex(row:int, col:int):void
		{
			_row = row;
			_col = col;
		}
	}
}