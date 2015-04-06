package game
{	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.System;
	
	import flashx.textLayout.operations.SplitParagraphOperation;
	
	import village.BuildModeMenu;
	import village.VillageState;
	import village.buildings.BasicBuilding;
	import village.buildings.BuildingInfo;
	import village.buildings.BuildingSprite;
	import village.notices.BasicNotice;
	import village.notices.NoticeResponseType;
	import village.tiles.Tile;
	import village.tiles.TileGrid;
	import village.tiles.TileIndexMap;

	public class TileGridScreen extends BasicScreen
	{
		private var buildingSprites : Vector.<BuildingSprite>;
		private var selectedSpriteIndex : int;
		private var worldScreen : WorldScreen;
		
		private var buildModeMenu : BuildModeMenu;
		
		public function TileGridScreen(game:MainGame, canvas:MainCanvas, parent:WorldScreen) {
			super(game, canvas);
			buildingSprites = new Vector.<BuildingSprite>();
			worldScreen = parent;
			
			buildModeMenu = new BuildModeMenu();
			buildModeMenu.addEventListener(BuildModeMenu.MOVE, moveSelected);
			buildModeMenu.addEventListener(BuildModeMenu.DESTROY, destroySelected);
			buildModeMenu.addEventListener(BuildModeMenu.ROTATE, rotateSelected);
			this.addChild(buildModeMenu);
			buildModeMenu.visible = false;
		}
		
		public function addBuildingSprite(newBuilding:BuildingInfo,
										  occupiedTiles:TileIndexMap,
										  tileGrid:TileGrid):void {
			var newBuildingSprite:BuildingSprite = new BuildingSprite(newBuilding);
			newBuildingSprite.moveToTile(occupiedTiles, tileGrid);
			
			newBuildingSprite.addEventListener(MouseEvent.CLICK, onSpriteClick);
			
			buildingSprites.push(newBuildingSprite);
			addChild(buildingSprites[buildingSprites.length-1]);
			sortSpriteLayers();
		}
		private function removeBuildingSprite(atIndex:int):void {
			try{
				removeChild(buildingSprites[atIndex]);
			}catch (e:Error){
				trace(e.message);
			}
			buildingSprites.splice(atIndex, 1);
			buildModeMenu.visible = false;
		}
		
		
		private function sortSpriteLayers():void {
			buildingSprites.sort(sortBuildingSprites);
			
			for (var i:int = 0; i < buildingSprites.length; i++) {
				this.setChildIndex(buildingSprites[i], i);
			}
		}
		private function sortBuildingSprites(a:BuildingSprite, b:BuildingSprite):int {
			if (a.layerIndex < b.layerIndex)
				return -1;
			else if (a.layerIndex == b.layerIndex)
				return 0;
			else
				return 1;
		}
		
		
		
		public function onStateChange():void {
			switch (worldScreen.state) {
				case VillageState.NORMAL:
					buildModeMenu.visible = false;
					break;
			}
		}		
		
		private function onSpriteClick(e:Event):void {
			
			switch (worldScreen.state) {
				case VillageState.NORMAL:
					worldScreen.notice.dispatchNotice(new BasicNotice(500, 500, NoticeResponseType.OKCANCEL));
					break;
				
				case VillageState.BUILD:
				case VillageState.DECO:
				case VillageState.DESTROY:
					
					var selectedSpriteBuilding:BuildingSprite = (e.currentTarget as BuildingSprite)
					for (var i:int = 0; i < buildingSprites.length; i++) {
						if (buildingSprites[i] == selectedSpriteBuilding) {
							selectedSpriteIndex = i;
							buildModeMenu.resetButtons(selectedSpriteBuilding.x, 
								selectedSpriteBuilding.y, true, true, true);
							buildModeMenu.visible = true;
							break;
						}
					}
					
					break;
			}
		}
	
		private function moveSelected(e:Event = null):void {
			worldScreen.onMoveBuilding(buildingSprites[selectedSpriteIndex]);
			removeBuildingSprite(selectedSpriteIndex);
		}
		private function destroySelected(e:Event = null):void {
			//add prompt later
			worldScreen.onDeleteBuilding(buildingSprites[selectedSpriteIndex]);
			removeBuildingSprite(selectedSpriteIndex);
		}
		private function rotateSelected(e:Event = null):void {
			
		}
	}
}