package animation
{
	import flash.geom.Rectangle;
	
	public class MovieClipData
	{
		private var _frames:Array;
		
		private var _rect:Rectangle;
		public function get rect():Rectangle { return _rect; };
		
		public function MovieClipData(data:Array, rect:Rectangle)
		{
			_frames = data;
			_rect = rect;
		}
		
		public function getFrameAt(index:int):AnimationFrame
		{
			if(index >= 0 && index < _frames.length)
				return _frames[index];
			else
				return null;
		}
		
		public function get frameCount():int
		{
			return _frames.length;
		}
	}
}