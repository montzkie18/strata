package common
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class HudButton extends Sprite
	{
		private const FRAME_NORMAL 	: int = 1;
		private const FRAME_OVER	: int = 2;
		private const FRAME_DOWN	: int = 3;	
		
		private var _mc : MovieClip;
		
		//Name for hover text
		
		public function HudButton(x:Number, y:Number, mc:MovieClip, clickListener:Function,
								  height:Number = 0, width:Number = 0) {
			this.x = x;
			this.y = y;
			
			_mc = mc;
			_mc.gotoAndStop(FRAME_NORMAL);
			
			if (height != 0)
				_mc.height = height;
			
			if (width != 0)
				_mc.width = width;
			
			addChild(_mc);
			this.buttonMode = true;
			this.useHandCursor = true;
			
			this.addEventListener(MouseEvent.CLICK, clickListener);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function onMouseOver(e:Event):void {
			try{
				_mc.gotoAndStop(FRAME_OVER);
			} catch(e:Error) {
				trace("[Hud Button] Failed to change Movie Clip frame: " + e.message);
			}
		}
		
		private function onMouseDown(e:Event):void {
			try{
				_mc.gotoAndStop(FRAME_DOWN);
			} catch(e:Error) {
				trace("[Hud Button] Failed to change Movie Clip frame: " + e.message);
			}
		}
		
		private function onMouseOut(e:Event):void {
			try{
				_mc.gotoAndStop(FRAME_NORMAL);
			} catch(e:Error) {
				trace("[Hud Button] Failed to change Movie Clip frame: " + e.message);
			}
		}
	}
}