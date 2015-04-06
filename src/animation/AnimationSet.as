package animation
{
	public class AnimationSet
	{
		private var _name:String;
		public function get name():String { return _name; };
		
		private var _startIndex:int;
		public function get startIndex():int { return _startIndex; };
		
		private var _endIndex:int;
		public function get endIndex():int { return _endIndex; };
		
		public function AnimationSet(name:String, start:int, end:int)
		{
			_name = name;
			_startIndex = start;
			_endIndex = end;
		}

	}
}