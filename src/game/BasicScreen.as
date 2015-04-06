/**
 * @class BasicScreen
 * Base class for all game screens.
 * You need to override event handlers for specific screen functions.
 */

package game
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BasicScreen extends Sprite
	{
		private var _game:MainGame;
		private var _canvas:MainCanvas;
		
		private var _bitmap:Bitmap;
		
		public function BasicScreen(game:MainGame, canvas:MainCanvas)
		{
			_game = game;
			_canvas = canvas;
			addEventListener(Event.ADDED_TO_STAGE, initialize, false, 0, true);
		}
		
		/**
		 * This should be where the initialization and instantiation
		 * of screen elements should be placed.
		 */
		protected function initialize(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			// initialize bitmap where we can draw objects
			resize(stage.width, stage.height);
		}
		
		/**
		 * Returns the current game instance
		 */
		protected function get gameClass():MainGame
		{
			return _game;
		}
		
		/**
		 * Returns the current canvas instance
		 */ 
		protected function get canvas():MainCanvas
		{
			return _canvas;
		}
		
		protected function get bitmapData():BitmapData
		{
			if(_bitmap != null)
				return _bitmap.bitmapData;
			else
				return new BitmapData(1, 1);
		}
		
		/**
		 * Blits an image or movieclip directly on screen.
		 */ 
		protected function draw(data:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, 
								blendMode:String = null, clipRect:Rectangle = null, smoothing:Boolean = false):void
		{
			_bitmap.bitmapData.draw(data, matrix, colorTransform, blendMode, clipRect, smoothing);
		}
		
		/**
		 * Clears the current screen.
		 */ 
		protected function clearScreen(bgColor:uint = 0x00FFFFFF):void
		{
			var bd:BitmapData = _bitmap.bitmapData;
			_bitmap.bitmapData.fillRect(new Rectangle(0, 0, bd.width, bd.height), bgColor);
		}
		
		/**
		 * Resize the current screen and re-initializes the canvas bitmap.
		 */ 
		protected function resize(newWidth:int, newHeight:int):void
		{
			if(_bitmap != null) {
				removeChild(_bitmap);
				_bitmap = null;
			}
			
			var bd:BitmapData = new BitmapData(newWidth, newHeight, true, 0xFFFFFF);
			_bitmap = new Bitmap(bd);
			
			addChildAt(_bitmap, 0);
		}
		
		/**
		 * Place all removing, deleting and deallocating code here.
		 */ 
		public function destroy():void 
		{
			
		}
		
		/**
		 * Handles all the screen updates.
		 * @return Boolean true to update the lower screen in the stack
		 */ 
		public function update(timeElapsedMs:Number):Boolean
		{
			return true;
		}
		
		/**
		 * Handles events during mouse down state
		 * @return Boolean true to handle events in the lower screen in the stack
		 */ 
		public function onMouseDown(pt:Point):Boolean
		{
			return true;
		}
		
		/**
		 * Handles events during mouse up state
		 * @return Boolean true to handle events in the lower screen in the stack
		 */ 
		public function onMouseUp(pt:Point):Boolean
		{
			return true;
		}
		
		/**
		 * Handles events during mouse movement
		 * @return Boolean true to handle events in the lower screen in the stack
		 */ 
		public function onMouseMove(pt:Point):Boolean
		{
			return true;
		}
		
		/**
		 * Handles events during key down state
		 * @return Boolean true to handle events in the lower screen in the stack
		 */ 
		public function onKeyDown():Boolean
		{
			return true;
		}
		
		/**
		 * Handles events during key presses
		 * @return Boolean true to handle events in the lower screen in the stack
		 */ 
		public function onKeyUp():Boolean
		{
			return true;
		}
	}
}