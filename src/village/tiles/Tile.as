package village.tiles
{
	import common.Utils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mithril.CBmpSprite;
	
	public class Tile
	{
		public static const TILE_WIDTH:int = 36;
		public static const TILE_HEIGHT:int = 18;
		
		private var _row:int;
		private var _col:int;
		
		private var _image:MovieClip;
		
		private var _rect:Rectangle;
		private var _screenPos:Point;
		
		public var isOccupied:Boolean;
		
		public function Tile(row:int, col:int)
		{
			_row = row;
			_col = col;
		}
		
		public function setImage(image:MovieClip):void
		{
			_image = image;
			_rect = new Rectangle(screenPos.x, screenPos.y, _image.width, _image.height);
		}
		
		public function removeImage():void
		{
			_image = null;
			_rect = null;
		}
		
		public function isDrawable():Boolean
		{
			return (_image != null);
		}
		
		public function hasPoint(point:Point, gridType:GridType):Boolean
		{
			var bounds:Rectangle = new Rectangle(screenPos.x, screenPos.y, rect.width, rect.height);
			if(gridType == GridType.ORTHOGRAPHIC)
			{
				return bounds.containsPoint(point);
			}
			else if(gridType == GridType.ISOMETRIC)
			{
				var polygon:Array = new Array();
				polygon.push(new Point(bounds.x + Tile.TILE_WIDTH /2, bounds.y));
				polygon.push(new Point(bounds.x + Tile.TILE_WIDTH, bounds.y + Tile.TILE_HEIGHT /2));
				polygon.push(new Point(bounds.x + Tile.TILE_WIDTH /2, bounds.y + Tile.TILE_HEIGHT));
				polygon.push(new Point(bounds.x, bounds.y + Tile.TILE_HEIGHT /2));
				polygon.push(new Point(bounds.x + Tile.TILE_WIDTH /2, bounds.y));
				
				return Utils.isInsidePolygon(polygon, point);
			}
			
			return false;
		}

		public function get image():MovieClip
		{
			if(_image != null)
				return _image;
			else
				return new MovieClip();
		}
		
		public function get rect():Rectangle
		{
			if(_rect != null)
				return _rect;
			else
				return new Rectangle();
		}
		
		public function get screenPos():Point
		{
			if(_screenPos != null)
				return _screenPos;
			else
				return new Point();
		}
		
		public function set screenPos(position:Point):void
		{
			_screenPos = position;
		}
		
		public function get row():int 
		{
			return _row;
		}
		
		public function get col():int
		{
			return _col;
		}
		
		public function get top():Point
		{
			var x:Number = _rect.x + (_rect.width/2);
			return new Point(x, _rect.y);
		}
		
		public function get left():Point
		{
			var y:Number = _rect.y + (_rect.height/2);
			return new Point(_rect.x, y);
		}
		
		public function get right():Point
		{
			var x:Number = rect.x + (_rect.width);
			var y:Number = rect.y + (_rect.height/2);
			return new Point(x, y);
		}
		
		public function get bottom():Point
		{
			var x:Number = rect.x + (_rect.width/2);
			var y:Number = rect.y + (_rect.height);
			return new Point(x, y);
		}
	}
}