package game
{	
	import Assets.BuildButton;
	import Assets.CancelButton;
	import Assets.DecoModeButton;
	import Assets.DestroyMode;
	import Assets.Farm;
	import Assets.HUD_Neighbor;
	import Assets.House;
	import Assets.HudFrameBackground;
	import Assets.HuntersLodge;
	import Assets.Sawmill;
	import Assets.TownHall;
	import Assets.Warehouse;
	
	import common.HudButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import village.PlayerResources;
	import village.VillageState;

	public class HudScreen extends BasicScreen
	{
		private var gameScreen			: GameScreen;
		private var hudFrame			: MovieClip;
		private var resourceInfo		: TextField;
		private var currentState		: TextField;
		
		//Temp Buttons
		private var townHallButton		: HudButton;
		private var houseButton			: HudButton;
		private var warehouseButton 	: HudButton;
		private var farmButton			: HudButton;
		private var huntersLodgeButton	: HudButton;
		private var sawmillButton		: HudButton;
		
		private var buildModeButton		: HudButton;
		private var cancelBuildButton	: HudButton;
		//acceptBuildButton
		private var decoModeButton		: HudButton;
		private var destroyModeButton	: HudButton;
		
		
		
		public function HudScreen(game:MainGame, 
								  canvas:MainCanvas, 
								  gameScreen:GameScreen) {
			super(game, canvas);
			this.gameScreen = gameScreen
				
			this.mouseEnabled = false;
		}
		
		protected override function initialize(event:Event=null):void {
			super.initialize(event);
			
			showCurrentState();
			
			drawBackgrounds();
			displayResources();
			
			initializeUIButtons();
			initializeBuildingSelection();
			
			//Jojo - SWF loading and manipulation test
			/*
			var HudClass:Class = ResourceManager.getDefinitionClass("SWF_UI_CLASSES","ScreenLoadingMC");
			var hudTemp:MovieClip = (new HudClass()) as MovieClip;
			hudTemp.loadingBarFill_mc.width -=60;
			addChild(hudTemp);
			*/	
		}
		
		public function onStateChanged():void {
			switch(gameScreen.villageState) {
				case VillageState.NORMAL:
					currentState.text = "Production Mode";
					showNormalStateButtons();
					hideBuildModeButtons();
					hideBuildingMenu();
					break;
				
				case VillageState.BUILD:
					currentState.text = "Build Mode";
					showBuildModeButtons();
					showBuildingMenu();
					hideNormalStateButtons();
					break;
				
				case VillageState.DECO:
					currentState.text = "Deco Mode";
					break;
				
				case VillageState.DESTROY:
					currentState.text = "Destroy Mode";
					break;
				
				case VillageState.BUY:
					currentState.text = "Buy Mode";
					break;
			}
		}
		
		/**
		 * Background HUD
		 **/
		private function drawBackgrounds():void {
			//HUD Lower Bar
			hudFrame = new Assets.HudFrameBackground();
			
			var matrix:Matrix = new Matrix();
			matrix.translate((MainCanvas.STAGE_WIDTH - hudFrame.width)/2,
					MainCanvas.STAGE_HEIGHT - hudFrame.height);
			draw(hudFrame, matrix);
		}
		
		/**
		 * Buttons
		 **/
		private function initializeUIButtons():void {
			buildModeButton = new HudButton(MainCanvas.STAGE_WIDTH - 180, MainCanvas.STAGE_HEIGHT - 70, 
				new BuildButton, onBuildModeClicked);
			cancelBuildButton = new HudButton(MainCanvas.STAGE_WIDTH - 180, MainCanvas.STAGE_HEIGHT - 100, 
				new CancelButton, onCancelBuildClicked);
			decoModeButton = new HudButton(MainCanvas.STAGE_WIDTH - 180, MainCanvas.STAGE_HEIGHT - 125,
				new DecoModeButton, onDecoModeClicked);
			destroyModeButton = new HudButton(MainCanvas.STAGE_WIDTH - 130, MainCanvas.STAGE_HEIGHT - 125,
				new DestroyMode, onDestroyModeClicked);
			
			this.addChild(buildModeButton);
			this.addChild(cancelBuildButton);
			this.addChild(decoModeButton);
			this.addChild(destroyModeButton);
		}
		
		private function initializeBuildingSelection():void {
			townHallButton = new HudButton(220, MainCanvas.STAGE_HEIGHT - 120, 
				new TownHall, gameScreen.townhall_click, 50, 50);
			houseButton = new HudButton(260, MainCanvas.STAGE_HEIGHT - 120, 
				new House, gameScreen.house_click, 50, 50);
			warehouseButton = new HudButton(300, MainCanvas.STAGE_HEIGHT - 120, 
				new Warehouse, gameScreen.warehouse_click, 50, 50);
			farmButton = new HudButton(340, MainCanvas.STAGE_HEIGHT - 120, 
				new Farm, gameScreen.farm_click, 50, 50);
			huntersLodgeButton = new HudButton(380, MainCanvas.STAGE_HEIGHT - 120, 
				new HuntersLodge, gameScreen.hunters_click, 50, 50);
			sawmillButton = new HudButton(420, MainCanvas.STAGE_HEIGHT - 120, 
				new Sawmill, gameScreen.sawmill_click, 50, 50);
			
			addChild(townHallButton);
			addChild(houseButton);
			addChild(warehouseButton);
			addChild(farmButton);
			addChild(huntersLodgeButton);
			addChild(sawmillButton);
		}	
		
		private function showNormalStateButtons():void {
			buildModeButton.visible = true;
		}
		private function hideNormalStateButtons():void {
			buildModeButton.visible = false;
		}
		private function showBuildModeButtons():void {
			decoModeButton.visible = true;
			destroyModeButton.visible = true;
			cancelBuildButton.visible = true;
		}
		private function hideBuildModeButtons():void {
			decoModeButton.visible = false;
			destroyModeButton.visible = false;
			cancelBuildButton.visible = false;
		}
		
		private function showBuildingMenu():void {
			townHallButton.visible = true;
			houseButton.visible = true;
			warehouseButton.visible = true;
			farmButton.visible = true;
			huntersLodgeButton.visible = true;
			sawmillButton.visible = true;
		}
		private function hideBuildingMenu():void {
			townHallButton.visible = false;
			houseButton.visible = false;
			warehouseButton.visible = false;
			farmButton.visible = false;
			huntersLodgeButton.visible = false;
			sawmillButton.visible = false;
		}
		
		private function onBuildModeClicked(e:Event):void {
			gameScreen.setStateAndNext(VillageState.BUILD, VillageState.DECO);
		}
		private function onCancelBuildClicked(e:Event):void {
			gameScreen.setState(VillageState.NORMAL);
		}
		private function onDecoModeClicked(e:Event):void {
			gameScreen.setState(VillageState.DECO);
		}
		private function onDestroyModeClicked(e:Event):void {
			gameScreen.setState(VillageState.DESTROY);
		}
		
		
		/**
		 * Resources
		 **/
		private function displayResources():void {
			gameClass.resourcePool.addEventListener(
				PlayerResources.RESOURCE_CHANGED, updateResourceHUD);
			resourceInfo = new TextField();
			resourceInfo.x = 50;
			resourceInfo.y = 50;
			resourceInfo.background = true;
			resourceInfo.autoSize = TextFieldAutoSize.LEFT;
			updateResourceHUD();
			addChild(resourceInfo);
		}
		
		private function updateResourceHUD(event:Event=null):void {
			resourceInfo.text = "FOOD = " + gameClass.resourcePool.resources.food +  
				"/" + gameClass.resourcePool.storage + 
				"   WOOD = " + gameClass.resourcePool.resources.wood + 
				"/" + gameClass.resourcePool.storage + 
				"   ORE = "  + gameClass.resourcePool.resources.ore + 
				"/" + gameClass.resourcePool.storage +
				"   POPULATION = " + gameClass.resourcePool.resources.population + 
				"/" + gameClass.resourcePool.upkeep;
		}

		
		//Temp Log
		private function showCurrentState():void {
			currentState = new TextField();
			currentState.x = 600;
			currentState.y = 50;
			currentState.background = true;
			currentState.autoSize = TextFieldAutoSize.LEFT;
			addChild(currentState);
		}
	}
}