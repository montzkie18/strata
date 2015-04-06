package game
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class InputManager
	{
		//! An array of boolean values indicating the state of the keyboard
		//! as well as the mouse for input processing.
		private var aKBState:Array;
		
		private var aKBKeyPressed:Array;
		
		//! Mouse Coordinates
		private var currentGlobalMousePt:Point;
		private var previousGlobalMousePt:Point;
		
		private var bIsMouseDown:Boolean;
		private var bIsMouseMoving:Boolean = false;
		
		//! helper variable to store current mouse displacement.
		private var _mouseDisplacement:Point;
		public function get mouseDisplacement():Point { return _mouseDisplacement; }
		
		//! helper variable to store current mouse position.
		private var _mousePoint:Point;
		public function get mousePoint():Point { return _mousePoint; }
		
		public function InputManager()
		{
			aKBState = new Array();
			aKBKeyPressed = new Array();
			
			currentGlobalMousePt = new Point();
			previousGlobalMousePt = new Point();
			_mouseDisplacement = new Point();
			
			_mousePoint = new Point();
		}
		
		//! ----------------------------------------------------------------
		//! Main Functions
		//! ----------------------------------------------------------------
		//! These functions should be the ones invoked on screens to check the
		//! 	the state of whatever input key or event is being pressed.
		/**
		 * Returns whether or not a specific key has been pressed.
		 */
		public function isKeyPressed(keyCode:int):Boolean
		{
			if (aKBState[keyCode])
			{
				aKBState[keyCode] = false;
				return true;
			}
			
			return false;
		}
		
		
		//! Checks if the specified key is continuously being held down by the user.
		public function isKeyHeldDown(keyCode:int):Boolean
		{	
			return aKBKeyPressed[keyCode];
		}
		
		public function isMouseDown():Boolean
		{
			return bIsMouseDown;
		}
		
		//! ----------------------------------------------------------------
		//! Event Listeners Callback Functions
		//! ----------------------------------------------------------------
		public function handleKeyDown(event:KeyboardEvent):void
		{
			if (aKBState[event.keyCode] || aKBKeyPressed[event.keyCode])
				return;
			
			aKBState[event.keyCode] = true;
			aKBKeyPressed[event.keyCode] = true;
		}
		
		
		public function handleKeyUp(event:KeyboardEvent):void
		{
			aKBState[event.keyCode] = false;
			aKBKeyPressed[event.keyCode] = false;
		}
		
		public function handleMouseUp(event:MouseEvent):void
		{
			bIsMouseDown = false;
			bIsMouseMoving = false;
		}
		
		public function handleMouseDown(event:MouseEvent):void
		{
			bIsMouseDown = true;
			
			var target:* = event.target;
			_mousePoint.x = target.mouseX;
			_mousePoint.y = target.mouseY;
			
			currentGlobalMousePt = target.localToGlobal(_mousePoint);
		}
		
		public function handleMouseMove(event:MouseEvent):void
		{
			bIsMouseMoving = true;
			
			previousGlobalMousePt.x = currentGlobalMousePt.x;
			previousGlobalMousePt.y = currentGlobalMousePt.y;
			
			var target:* = event.target;
			_mousePoint.x = target.mouseX;
			_mousePoint.y = target.mouseY;
			
			currentGlobalMousePt = target.localToGlobal(_mousePoint);
			
			_mouseDisplacement.x = currentGlobalMousePt.x - previousGlobalMousePt.x;
			_mouseDisplacement.y = currentGlobalMousePt.y - previousGlobalMousePt.y;
		}
	}
}