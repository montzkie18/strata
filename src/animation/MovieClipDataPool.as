package animation
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class MovieClipDataPool extends EventDispatcher
	{
		public static const COPY_COMPLETE:String = "mc_copy_complete";
		public static const COPY_PROGRESS:String = "mc_copy_progress";
		
		private var _dataMap:Dictionary;
		
		public function MovieClipDataPool()
		{
			_dataMap = new Dictionary();
		}
		
		public function hasClip(name:String):Boolean
		{
			return _dataMap[name] != null;
		}
		
		public function getClip(name:String):MovieClipData
		{
			if(hasClip(name))
				return _dataMap[name] as MovieClipData;
			else
				return null;
		}
		
		public function copyClip(mc:MovieClip, name:String, scale:Number = 1, clipPoint:Point = null):void
		{
			var rect:Rectangle = new Rectangle(0, 0, mc.width, mc.height);
			var frameCount:int = mc.framesLoaded;
			var frameIndex:int = 0;
			
			var clipOffset:Point = clipPoint == null ? new Point() : clipPoint;
			var frames:Array = new Array();
			
			for(frameIndex = 0; frameIndex < frameCount; frameIndex++)
			{
				mc.gotoAndStop(frameIndex);
		
				var frameRect:Rectangle = getFrameRect(mc, scale, clipOffset);
				if(frameRect.width > rect.width)
					rect.width = frameRect.width;
				if(frameRect.height > rect.height)
					rect.height = frameRect.height;
				
				var bitmapData:BitmapData = copyFrame(mc, rect, frameRect, scale, clipOffset);
				
				frames.push(new AnimationFrame(bitmapData, frameRect, frameIndex, mc.currentFrameLabel));
				
				dispatchEvent(new Event(COPY_PROGRESS));
			}
			
			_dataMap[name] = new MovieClipData(frames, rect);
			dispatchEvent(new Event(COPY_COMPLETE));
		}
		
		private function copyFrame(mc:MovieClip, rect:Rectangle, frameRect:Rectangle, scale:Number, clipOffset:Point):BitmapData
		{
			var transform:Matrix = new Matrix();
			transform.scale(scale, scale);
			transform.translate(-clipOffset.x * scale, -clipOffset.y * scale);
			
			var bitmapData:BitmapData;
			// Check if frame is empty
			if (frameRect.width > 0 && frameRect.height > 0) {
				bitmapData = new BitmapData(rect.width, rect.height, true, 0x00FFFFFF);
			}else {
				bitmapData = new BitmapData(1, 1, true, 0x00FFFFFF);
				frameRect.width = 1;
				frameRect.height = 1;
			}
			bitmapData.draw(mc, transform, null, null, null, true);
			
			return bitmapData;
		}
		
		private function getFrameRect(mc:MovieClip, scale:Number, clipOffsetPoint:Point):Rectangle
		{
			var bounds:Rectangle = mc.getRect(mc);
			var newWidth:Number = (bounds.x + bounds.width - clipOffsetPoint.x) * scale;
			var newHeight:Number = (bounds.y + bounds.height - clipOffsetPoint.y) * scale;
			
			return new Rectangle(0, 0, newWidth, newHeight);
		}
	}
}