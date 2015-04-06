package village.buildings
{
	import Assets.Farm;
	import Assets.House;
	import Assets.HuntersLodge;
	import Assets.Sawmill;
	import Assets.TownHall;
	import Assets.Warehouse;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import game.ResourceManager;
	
	import village.tiles.Tile;
	import village.tiles.TileGrid;
	import village.tiles.TileIndex;
	import village.tiles.TileIndexMap;
	
	public class BuildingSprite extends MovieClip
	{
		private var _building : BuildingInfo;
		public function get buildingInfo():BuildingInfo {return _building;}
		public function get building():BasicBuilding {return _building.building;}
		
		private var _layerIndex : int;
		public function get layerIndex():int {return _layerIndex;}
		
		private var _onTileIndexMap : TileIndexMap;
		public function get onTileIndexMap():TileIndexMap {return _onTileIndexMap;}
		
		public function BuildingSprite(buildingInfo:BuildingInfo) {
			super();
			_building = buildingInfo;
			loadSprite();
		}
		
		public function moveToTile(occupiedTiles:TileIndexMap, tileGrid:TileGrid):void {	
			displayOnTile(occupiedTiles.mainTile);
			
			_onTileIndexMap = occupiedTiles;
			_layerIndex = occupiedTiles.mainTile.row + occupiedTiles.mainTile.col
						+ occupiedTiles.centerY;
			
			_building.tileIndex = new TileIndex(occupiedTiles.mainTile.row, 
						occupiedTiles.mainTile.col);
		}
		
		public function displayOnTile(tile:Tile):void {
			this.x = tile.bottom.x - (this.width * 
						(building.cellColumn/(building.cellRow + building.cellColumn)));
			this.y = tile.bottom.y - this.height - building.bottomOffset;
		}
		
		//Temp
		private function loadSprite():void {
			var spriteClass:Class = ResourceManager.getDefinitionClass(
					"SWF_BUILDINGS_PLACEHOLDER",building.spriteClass);
			
			this.addChild(new spriteClass);
		}
	}
}