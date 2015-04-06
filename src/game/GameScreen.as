package game
{	
	import Assets.GridTile7;
	import Assets.TileOutline;
	import Assets.VillageBGPlaceholder;
	import Assets.VillageBackground;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.primitives.Rect;
	
	import village.VillageState;
	import village.VillageStateManager;
	import village.buildings.BasicBuilding;
	import village.buildings.BuildingInfo;
	import village.tiles.Tile;
	import village.tiles.TileIndexMap;

	public class GameScreen extends BasicScreen
	{
		// this layer contains the main play area
		// which includes the game background, tiles, structures, animating units and decors
		private var world:WorldScreen;
		
		// this layer contains the User Interface
		private var hud:HudScreen;
		
		// this layer shows notifications to the player if there are any
		private var _notice:NoticeScreen;
		public function get notice():NoticeScreen {return _notice;}
		
		private var _villageStateManager : VillageStateManager;
		public function get villageState():VillageState {return _villageStateManager.villageState;}
		public function get previousState():VillageState {return _villageStateManager.previousState;}
		
		public function GameScreen(game:MainGame, canvas:MainCanvas) {
			super(game, canvas);
			trace("Game screen loaded!");
		}
		
		protected override function initialize(event:Event = null):void	{
			super.initialize(event);
			
			world = new WorldScreen(gameClass, canvas, this);
			addChild(world);
			
			hud = new HudScreen(gameClass, canvas, this);
			addChild(hud);
			
			_notice = new NoticeScreen(gameClass, canvas);
			addChild(_notice);
			
			// Background. This should be loaded from database
			var bgClass:Class = ResourceManager.getDefinitionClass("SWF_MAP_PLACEHOLDER","Assets.VillageBackground");
			world.changeBackground(new bgClass());
			
			// sample grid size and asset
			// this should be loaded from database
			var rowSize:int = 20;
			var colSize:int = 20;
			world.setTileSize(rowSize, colSize);
			
			var tile:MovieClip = new Assets.TileOutline();
			for(var i:int = 0; i<rowSize; i++)
			{
				for(var j:int = 0; j<colSize; j++)
				{
					world.setTileImage(tile, i, j);
				}
			}
			
			world.redrawBackground();
			world.focusCenter();
			
			_villageStateManager = new VillageStateManager();
			_villageStateManager.addEventListener(
				VillageStateManager.STATE_CHANGED, onVillageStateChange);
			setState(VillageState.NORMAL);
			//onVillageStateChange(new Event(VillageStateManager.STATE_CHANGED));
			
//			world.scaleX = 3;
//			world.scaleY = 3;
//			world.redrawBackground();
		}
		
		public override function destroy():void	{
			_villageStateManager.removeEventListener(
				VillageStateManager.STATE_CHANGED, onVillageStateChange);
			_villageStateManager = null;
			
			world.destroy();
			world = null;
		}
		
		public override function update(timeElapsedMs:Number):Boolean {
			_notice.update(timeElapsedMs);
			return true;
		}
		
		
		/**
		 * Input Events
		 **/
		public override function onKeyDown():Boolean {
			return true;
		}
		
		public override function onKeyUp():Boolean {
			return true;
		}
		
		public override function onMouseDown(pt:Point):Boolean {
			if (!notice.isLocked) {
				world.onMouseDown(pt);
			}
			return true;
		}
		
		public override function onMouseMove(pt:Point):Boolean {
			if (!notice.isLocked) {
				world.onMouseMove(pt);
			}
			return true;
		}
		
		public override function onMouseUp(pt:Point):Boolean {
			return true;
		}
		
		
		/**
		 * States 
		 **/
		public function onVillageStateChange(e:Event):void {
			hud.onStateChanged();
			world.onStateChanged();
			_villageStateManager.nextState();
		}
		
		public function setState(state:VillageState):void {
			_villageStateManager.setState(state);
		}
		
		public function setStateAndNext(state:VillageState, 
										nextState:VillageState):void {
			_villageStateManager.setStateAndNext(state,nextState);
		}
		
		//public function nextState():void {_villageStateManager.nextState();}
		public function cancelState():void {_villageStateManager.cancelState();}
		
		
		/**
		 * Input from HUD
		 **/
		private function buyBuilding(buildingName:String):void {
			var selectedBuilding:BasicBuilding = gameClass.buildingTypePool.
						getBuildingDataByName(buildingName)
			
			if (gameClass.resourcePool.hasEnoughResources(selectedBuilding.cost)){
				world.onBuyBuilding(new BuildingInfo(selectedBuilding));
			}
		}
		
		////TEMP
		public function townhall_click(e:Event):void {buyBuilding("TownHall");}
		public function house_click(e:Event):void {buyBuilding("House");}
		public function warehouse_click(e:Event):void {buyBuilding("Warehouse");}
		public function farm_click(e:Event):void {buyBuilding("Farm");}
		public function hunters_click(e:Event):void {buyBuilding("HuntersLodge");}
		public function sawmill_click(e:Event):void {buyBuilding("Sawmill");}
	}
}