package game
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mithril.CScreen2D;
	
	import mx.collections.ArrayList;

	public class MainCanvas extends Sprite
	{
		public static const STAGE_WIDTH:Number = 760;
		public static const STAGE_HEIGHT:Number = 630;
		
		private var _screenStack:Vector.<Sprite>;
		
		private var _inputManager:InputManager;
		
		public function MainCanvas()
		{
			_screenStack = new Vector.<Sprite>();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}
		
		public function pushScreen(screen:Sprite):void
		{
			_screenStack.push(screen);
			addChild(screen);
		}
		
		public function removeScreen(screen:Sprite):void
		{
			var index:int = _screenStack.indexOf(screen);
			if(index >= 0) {
				_screenStack.splice(index, 1);
				removeChild(screen);
				
				// clear all attached objects
				(screen as BasicScreen).destroy();
			}
		}
		
		public function popScreen():void
		{
			if(_screenStack.length == 0) return;
			
			var screen:Sprite = _screenStack.pop();
			removeChild(screen);
			
			// clear all attached objects
			(screen as BasicScreen).destroy();
		}
		
		public function clearScreenStack():void
		{
			var numScreen:uint = _screenStack.length;
			for(var i:uint=0; i<numScreen; i++)
			{
				var screen:Sprite = _screenStack.pop();
				removeChild(screen);
				
				// clear all attached objects
				(screen as BasicScreen).destroy();
			}
		}
		
		public function updateScreen(timeElapsedMs:Number):void
		{
			var screenIndex:int = _screenStack.length - 1;
			for(var i:int = screenIndex; i >= 0; i--)
			{
				var child:Sprite = _screenStack[i];
				if(child is BasicScreen) {
					var screen:BasicScreen = BasicScreen(child);
					if(screen.update(timeElapsedMs)) break;
				}
			}
		}
		
		public function isKeyDown(keyCode:int):Boolean
		{
			return _inputManager.isKeyHeldDown(keyCode);
		}
		
		public function isKeyPressed(keyCode:int):Boolean
		{
			return _inputManager.isKeyPressed(keyCode);
		}
		
		public function isMouseDown():Boolean
		{
			return _inputManager.isMouseDown();
		}
		
		public function getMouseDisplacement():Point
		{
			return _inputManager.mouseDisplacement;
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_inputManager = new InputManager();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			_inputManager.handleKeyDown(event);
			for each(var screen:Sprite in _screenStack)
			{
				(screen as BasicScreen).onKeyDown();
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			_inputManager.handleKeyUp(event);
			for each(var screen:Sprite in _screenStack)
			{
				(screen as BasicScreen).onKeyUp();
			}
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			_inputManager.handleMouseDown(event);
			for each(var screen:Sprite in _screenStack)
			{
				(screen as BasicScreen).onMouseDown(_inputManager.mousePoint);
			}
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			_inputManager.handleMouseMove(event);
			for each(var screen:Sprite in _screenStack)
			{
				(screen as BasicScreen).onMouseMove(_inputManager.mousePoint);
			}
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			_inputManager.handleMouseUp(event);
			for each(var screen:Sprite in _screenStack)
			{
				(screen as BasicScreen).onMouseUp(_inputManager.mousePoint);
			}
		}
	}
}