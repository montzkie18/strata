package village.buildings
{
	import village.tiles.TileIndex;

	public class BuildingInfo
	{
		private var _building : BasicBuilding;
		public function get building():BasicBuilding {return _building;}
		
		public var tileIndex : TileIndex
		
		private var id : uint;
		
		public function BuildingInfo(building:BasicBuilding) {
			_building = building;
			tileIndex = new TileIndex(-1, -1);
		}
	}
}