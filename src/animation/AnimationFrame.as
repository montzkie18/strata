package animation
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class AnimationFrame
	{
		private var _frameData:BitmapData;
		public function get frameData():BitmapData { return _frameData; };
		
		private var _rect:Rectangle;
		public function get rect():Rectangle { return _rect; };
		
		private var _position:Point;
		public function get position():Point { return _position; };
		
		private var _index:int;
		public function get index():int { return _index; };
		
		private var _label:String;
		public function get label():String { return _label; };
		
		public function AnimationFrame(bd:BitmapData, rect:Rectangle, index:int, label:String)
		{
			_frameData = bd;
			_index = index;
			_label = label;
			_rect = new Rectangle();
			_rect.width = rect.width;
			_rect.height = rect.height;
			_position = new Point(rect.x, rect.y);
		}
	}
}