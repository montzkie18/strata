package game
{
	import flash.events.Event;
	import flash.text.TextField;
	
	public class LoadingScreen extends BasicScreen
	{
		private const ITEMS_TO_LOAD:int = 3;
		
		private var _txtLoading:TextField;
		
		private var _loadedItemCount:int;
		
		public function LoadingScreen(game:MainGame, canvas:MainCanvas)
		{
			super(game, canvas);
		}
		
		protected override function initialize(event:Event=null):void
		{
			super.initialize(event);
			
			_loadedItemCount = 0;
			
			// Place all Main Game initializations here..
			
			with(gameClass.tacticsInfoPool) {
				addEventListener(Event.COMPLETE, loadingCompleteHandler, false, 0, true);
				load("res/xml/tactics_info.xml");
			}
			
			with(gameClass.soldierAnimationPool) {
				addEventListener(Event.COMPLETE, loadingCompleteHandler, false, 0, true);
				load("res/xml/soldier_animation.xml");
			}
			
			with(gameClass.buildingTypePool) {
				addEventListener(Event.COMPLETE, loadingCompleteHandler, false, 0, true);
				load("res/xml/buildings_info.xml");
			}
			
			gameClass.battleActionPool.initialize();
			gameClass.animationActionPool.initialize();
			
			_txtLoading = new TextField();
			_txtLoading.text = "Loading...";
			_txtLoading.selectable = false;
			_txtLoading.x = (MainCanvas.STAGE_WIDTH - _txtLoading.width) / 2;
			_txtLoading.y = (MainCanvas.STAGE_HEIGHT - _txtLoading.height) / 2;
			addChild(_txtLoading);
		}
		
		public override function destroy():void
		{
			removeChild(_txtLoading);
			_txtLoading = null;
		}
		
		public override function update(timeElapsedMs:Number):Boolean
		{
			graphics.beginFill(0x000000, 1.0);
			graphics.drawRect(0, 0, MainCanvas.STAGE_WIDTH, MainCanvas.STAGE_HEIGHT);
			graphics.endFill();
			return true;
		}
		
		private function loadingCompleteHandler(event:Event):void
		{
			_loadedItemCount += 1;
			if(_loadedItemCount == ITEMS_TO_LOAD)
				gameClass.changeState(GameState.IN_VILLAGE);
		}
	}
}