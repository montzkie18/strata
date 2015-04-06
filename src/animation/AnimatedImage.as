package animation
{
	import common.Assertions;
	import common.Image;
	import common.Timer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.Rectangle;
	
	public class AnimatedImage extends Image
	{
		private var _animation:MovieClipData;
		
		private var _animationSet:AnimationSet;
		
		private var _animationIndex:int;
		private var _startIndex:int;
		private var _endIndex:int;
		
		private var _timer:Timer;
		
		public function AnimatedImage(anim:MovieClipData, frameRate:int = 30)
		{
			_animation = anim;
			_animationIndex = 0;
			
			Assertions.assert(_animation.frameCount > 0, "Invalid movie clip data.");
			super(_animation.getFrameAt(_animationIndex).frameData);
			
			_startIndex = 0;
			_endIndex = _animation.frameCount - 1;
			
			setFrameRate(frameRate);
		}
		
		public function update(timeMs:Number):void
		{
			_timer.update(timeMs);
			if(_timer.hasElapsed())
			{
				gotoNextFrame(_timer.timeElapsedRatio);
				_timer.reset();
			}
		}
		
		public function setFrameRate(frameRate:int):void
		{
			var secondsPerFrame:Number = 1.0 / frameRate;
			var msPerFrame:Number = secondsPerFrame * 1000;
			if(_timer == null)
				_timer = new Timer(msPerFrame);
			else
				_timer.reset(msPerFrame);
		}
		
		public function playData(anim:MovieClipData):void
		{
			_animation = anim;
			_animationIndex = -1;
			
			_startIndex = 0;
			_endIndex = _animation.frameCount - 1;

			gotoNextFrame(1);
			
			_animationSet = null;
			
			play();
		}
		
		public function playSet(set:AnimationSet):void
		{
			_animationSet = set;
			_animationIndex = -1;
			_startIndex = _animationSet.startIndex;
			_endIndex = _animationSet.endIndex - 1;
			gotoNextFrame(1);
			play();
		}
		
		public function isPlayingSet(name:String):Boolean
		{
			if(_animationSet == null)
				return false;
			else
				return _animationSet.name == name;
		}
		
		public function isPlaying():Boolean
		{
			return _timer.isRunning();
		}
		
		public function play():void
		{
			_timer.start();
		}
		
		public function pause():void
		{
			_timer.pause();
		}
		
		public function stop():void
		{
			_timer.reset();
			_timer.pause();
			_animationIndex = 0;
		}
		
		public override function get width():int
		{
			return _animation.rect.width;
		}
		
		public override function get height():int
		{
			return _animation.rect.height;
		}
		
		private function gotoNextFrame(elapsedFrames:int):void
		{
			_animationIndex += elapsedFrames;
			if(_animationIndex > _endIndex)
				_animationIndex = _startIndex;
			
			image = _animation.getFrameAt(_animationIndex).frameData;
		}
	}
}