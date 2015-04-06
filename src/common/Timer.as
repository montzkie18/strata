package common
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Timer extends EventDispatcher
	{
		public static const TIME_ELAPSED:String = "timeElapsed";
		
		private var _maxTimeMs:Number;
		private var _elapsedTimeMs:Number;
		
		private var _isRunning:Boolean;
		
		public function Timer(maxTimeMs:Number)
		{
			_maxTimeMs = maxTimeMs;
			_elapsedTimeMs = 0;
			_isRunning = false;
		}
		
		public function update(elapsedTimeMs:Number):void
		{
			if(_isRunning) {
				_elapsedTimeMs += elapsedTimeMs;
				if(hasElapsed()) {
					pause();
					dispatchEvent(new Event(TIME_ELAPSED));
				}
			}
		}
		
		public function hasElapsed():Boolean
		{
			return _elapsedTimeMs >= _maxTimeMs;
		}
		
		public function start():void
		{
			_isRunning = true;
		}
		
		public function pause():void
		{
			_isRunning = false;
		}
		
		public function reset(maxTime:Number = 0):void
		{
			_elapsedTimeMs = 0;
			if(maxTime > 0)
				_maxTimeMs = maxTime;
			start();
		}
		
		public function isRunning():Boolean
		{
			return _isRunning;
		}
		
		public function get timeElapsed():Number 
		{
			return _elapsedTimeMs;
		}
		
		public function get timeElapsedRatio():Number
		{
			return _elapsedTimeMs / _maxTimeMs;
		}
	}
}