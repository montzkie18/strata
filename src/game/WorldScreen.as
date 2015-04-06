package game
{
	import Assets.TownHall;
	
	import common.Utils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import village.PlayerResources;
	import village.VillageState;
	import village.buildings.BasicBuilding;
	import village.buildings.BuildingInfo;
	import village.buildings.BuildingSprite;
	import village.buildings.BuildingTypeDB;
	import village.notices.BasicNotice;
	import village.notices.NoticeResponseType;
	import village.tiles.GridType;
	import village.tiles.PathFinder;
	import village.tiles.Tile;
	import village.tiles.TileGrid;
	import village.tiles.TileIndexMap;

	public class WorldScreen extends BasicScreen
	{
		private var gameScreen			: GameScreen;
		
		private var background			: MovieClip;
		private var bgTransform			: Matrix;
		
		private var pathfinder			: PathFinder;
		private var tilegrid			: TileGrid;
		private var tileGridScreen		: TileGridScreen;
		
		private var heldBuildingSprite 	: BuildingSprite;
		private var isHoldingASprite 	: Boolean;
		
		public function get state():VillageState {return gameScreen.villageState;}
		public function get notice():NoticeScreen {return gameScreen.notice;}
		
		public function WorldScreen(game:MainGame, 
									canvas:MainCanvas,
									gameScreen:GameScreen) {
			super(game, canvas);
			this.gameScreen = gameScreen; 
		}
		
		protected override function initialize(event:Event=null):void {
			super.initialize(event);
			
			tilegrid = new TileGrid(GridType.ISOMETRIC, new Point(50, 150));
			pathfinder = new PathFinder(tilegrid);
			tileGridScreen = new TileGridScreen(gameClass, canvas, this);
			isHoldingASprite = false;
			bgTransform = new Matrix();
			
			this.addChild(tileGridScreen);
		}
		
		public override function destroy():void	{			
			tileGridScreen = null;
			background = null;
			
			pathfinder.destroy();
			pathfinder = null;
			
			heldBuildingSprite = null;
		}
		
		
		
		/**
		 * States
		 **/
		private function setState(state:VillageState):void {
			gameScreen.setState(state);
		}
		private function setStateAndNext(state:VillageState, 
										nextState:VillageState):void {
			gameScreen.setStateAndNext(state,nextState);
		}
		private function cancelState():void {gameScreen.cancelState();}
		
		public function onStateChanged():void {
			switch(state)
			{
				case VillageState.NORMAL:
					break;
				
				case VillageState.NOTICE:
					
					break;
				
				case VillageState.BUILD:
					//showGrid
					unsetBuildingDrag();
					break;
				
				case VillageState.DECO:

					break;
				
				case VillageState.DESTROY:
					
					break;
				
				case VillageState.BUY:
				case VillageState.MOVE:
					if (!startBuildingDrag()) {
						unsetBuildingDrag();
						cancelState();
					}
					break;
			}
			tileGridScreen.onStateChange();
		}
		
		
		
		/**
		 * Mouse Events
		 **/
		public override function onMouseMove(pt:Point):Boolean {
			panCamera();
			buildingFollowMouse();
			return true;
		}	
		
		private function panCamera():void {
			if(background == null) return;
			
			// handle mouse drag
			if(canvas.isMouseDown()) {
				var mouseDisplacement:Point = canvas.getMouseDisplacement();
				this.x = Utils.clamp(this.x + mouseDisplacement.x, MainCanvas.STAGE_WIDTH - background.width * this.scaleX, 0);
				this.y = Utils.clamp(this.y + mouseDisplacement.y, MainCanvas.STAGE_HEIGHT - background.height * this.scaleX, 0);
			}	
		}
		
		private function buildingFollowMouse():void	{
			if (!isHoldingASprite)
				return;
			
			var tileMouseOn : Tile = tilegrid.getTileAtPoint(new Point(mouseX, mouseY));
			if (tileMouseOn == null){
				heldBuildingSprite.x = mouseX - (heldBuildingSprite.width/2);
				heldBuildingSprite.y = mouseY - (heldBuildingSprite.height/2);
			} else {
				heldBuildingSprite.displayOnTile(tileMouseOn);
			}
			
			heldBuildingSprite.x += this.x;
			heldBuildingSprite.y += this.y;
		}
	
		public override function onMouseDown(pt:Point):Boolean {
			dropHeldBuilding();
			return true;
		}
		
		private function dropHeldBuilding():void {
			if (!isHoldingASprite)
				return;
			
			var tileMouseOn : Tile = tilegrid.getTileAtPoint(new Point(mouseX, mouseY));
			
			if (tileMouseOn == null)
				return;
			
			var occupiedTiles : TileIndexMap = new TileIndexMap(tileMouseOn,
				tilegrid.getTileAt(
					tileMouseOn.row - (heldBuildingSprite.building.cellRow -1),
					tileMouseOn.col - (heldBuildingSprite.building.cellColumn -1)),
				heldBuildingSprite.building.cellRow,
				heldBuildingSprite.building.cellColumn)
			
			if (!tilegrid.areTilesFree(occupiedTiles))
				return;
			
			if (state == VillageState.BUY)
				buyHeldBuilding(tileMouseOn, occupiedTiles);
			else if (state == VillageState.MOVE)
				moveHeldBuilding(tileMouseOn, occupiedTiles);
		}

		
		
		/**
		 * Buy/Move/Delete
		 **/
		private function buyHeldBuilding(tileMouseOn:Tile, occupiedTiles:TileIndexMap):void {
			if (gameClass.resourcePool.hasEnoughResources(heldBuildingSprite.building.cost)){
				gameClass.resourcePool.construct(heldBuildingSprite.buildingInfo, tileMouseOn);
				addBuildingSprite(heldBuildingSprite.buildingInfo, occupiedTiles);
				stopBuildingDrag();
			}
			
			cancelState();
		}
		
		private function moveHeldBuilding(tileMouseOn:Tile, occupiedTiles:TileIndexMap):void {
			addBuildingSprite(heldBuildingSprite.buildingInfo, occupiedTiles);
			stopBuildingDrag();
			cancelState();
		}
		
		public function onBuyBuilding(selectedBuilding:BuildingInfo):void	{
			setBuildingDrag(new BuildingSprite(selectedBuilding));
			setState(VillageState.BUY);
		}
		
		public function onMoveBuilding(selectedBuilding:BuildingSprite):void {
			setBuildingDrag(selectedBuilding);
			tilegrid.freeTiles(selectedBuilding.onTileIndexMap);
			setState(VillageState.MOVE);
		}
	
		public function onDeleteBuilding(selectedBuilding:BuildingSprite):void {
			gameClass.resourcePool.destroy(selectedBuilding.buildingInfo);
			tilegrid.freeTiles(selectedBuilding.onTileIndexMap);
		}
		
		private function setBuildingDrag(buildingSprite:BuildingSprite):void {
			heldBuildingSprite = buildingSprite;
			isHoldingASprite = true;
		}
		
		private function unsetBuildingDrag():void {
			isHoldingASprite = false;
			heldBuildingSprite = null;
		}
		
		private function startBuildingDrag():Boolean {
			if (!isHoldingASprite) return false;
		
			buildingFollowMouse();
			canvas.addChild(heldBuildingSprite);
			return true;
		}
		
		private function stopBuildingDrag():void {
			canvas.removeChild(heldBuildingSprite);
			unsetBuildingDrag();
		}
		
		private function addBuildingSprite(newBuilding:BuildingInfo, 
										   occupiedTiles:TileIndexMap):void	{
			tilegrid.occupyTiles(occupiedTiles);
			tileGridScreen.addBuildingSprite(newBuilding, occupiedTiles, tilegrid);
		}
		
		
		
		
		/**
		 * Tiles and Background
		 **/
		public function changeBackground(image:MovieClip):void {
			background = image;
			resize(background.width, background.height);
			focusCenter();
		}
		
		public function focusCenter():void {
			if(background != null) {
				this.x = (MainCanvas.STAGE_WIDTH - background.width * this.scaleX) / 2;
				this.y = (MainCanvas.STAGE_HEIGHT - background.height * this.scaleX) / 2;
			}
		}
		
		public function redrawBackground():void	{
			if(background != null){
				var bgMatrix:Matrix = new Matrix();
				bgMatrix.scale(scaleX, scaleY);
				draw(background, bgMatrix);
			}
			
			var row:int = tilegrid.getRowCount();
			var col:int = tilegrid.getColumnCount();
			for(var i:int = 0; i<row; i++) {
				for(var j:int = 0; j<col; j++) {
					var tile:Tile = tilegrid.getTileAt(i, j);
					if(tile.isDrawable()) {
						var matrix:Matrix = new Matrix;
						matrix.translate(tile.screenPos.x, tile.screenPos.y);
						draw(tile.image, matrix);
					}
				}
			}
		}
		
		public function setScale(scale:Number):void {
			bgTransform.scale(scale, scale);
			tileGridScreen.scaleX = tileGridScreen.scaleY = scale;
		}
		
		public function setTileSize(row:int, col:int):void {
			tilegrid.setGridSize(row, col);
		}
		
		public function setTileImage(image:MovieClip, row:int, col:int):void {
			var tile:Tile = tilegrid.getTileAt(row, col);
			if(tile != null)
				tile.setImage(image);
		}
		
		public function removeTileImage(row:int, col:int):void {
			var tile:Tile = tilegrid.getTileAt(row, col);
			if(tile != null)
				tile.removeImage();
		}
		
	}
}