package village
{
	import Assets.DecoModeButton;
	import Assets.DestroyMode;
	import Assets.RotateModeButton;
	
	import common.HudButton;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	public class BuildModeMenu extends Sprite
	{
		public static const MOVE : String = "move_button_clicked";
		public static const DESTROY : String = "destroy_button_clicked";
		public static const ROTATE : String = "rotate_button_clicked";
		
		private const UPPER_LEFT : Point = new Point(0, 30);
		private const CENTER : Point = new Point(33, 0);
		private const UPPER_RIGHT : Point = new Point(70, 30);
		
		private var moveButton : HudButton;
		private var destroyButton : HudButton;
		private var rotateButton : HudButton;
		
		private var showMoveButton : Boolean;
		private var showDestroyButton : Boolean;
		private var showRotateButton : Boolean;
		
		public function BuildModeMenu(//background:MovieClip, 
								  x:Number = 0, y:Number = 0, move:Boolean = true,
								  destroy:Boolean = true, rotate:Boolean = true) {
			this.x = x;
			this.y = y;
			
//			background.x -= background.width;
//			background.y -= backgroud.height;
//			this.addChild(background);
			
			showMoveButton = move;
			showDestroyButton = destroy;
			showRotateButton = rotate;
			
			moveButton = new HudButton(UPPER_LEFT.x, UPPER_LEFT.y, new Assets.DecoModeButton, onMoveClicked);
			destroyButton = new HudButton(UPPER_RIGHT.x, UPPER_RIGHT.y, new Assets.DestroyMode, onDestroyClicked);
			rotateButton = new HudButton(CENTER.x, CENTER.y, new Assets.RotateModeButton, onRotateClicked);
			
			this.addChild(moveButton);
			this.addChild(destroyButton);
			this.addChild(rotateButton);
			
			showButtons();
		}
		
		private function showButtons():void {
			moveButton.visible = showMoveButton;
			destroyButton.visible = showDestroyButton;
			rotateButton.visible = showRotateButton;
		}
		
		public function resetButtons(x:Number, y:Number, showMove:Boolean, 
									 showDestroy:Boolean, showRotate:Boolean):void {
			showMoveButton = showMove;
			showDestroyButton = showDestroy;
			showRotateButton = showRotate;
			
			this.x = x;
			this.y = y;
			
			showButtons();
		}
		
		private function onMoveClicked(e:Event):void {
			this.dispatchEvent(new Event(MOVE));
		}
		private function onDestroyClicked(e:Event):void {
			this.dispatchEvent(new Event(DESTROY));
		}
		private function onRotateClicked(e:Event):void {
			this.dispatchEvent(new Event(ROTATE));
		}
	}
}