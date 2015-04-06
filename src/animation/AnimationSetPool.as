package animation
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class AnimationSetPool extends EventDispatcher
	{
		private var _animationMap:Object;
		private var _urlLoader:URLLoader;
		
		public function AnimationSetPool()
		{
		}
		
		public function load(source:String):void
		{
			var request:URLRequest = new URLRequest(source);
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, xmlLoadedHandler);
			_urlLoader.load(request);
		}
		
		public function parse(xml:XML):void
		{
			_animationMap = new Object();
			
			var count:uint = 0;
			for each(var anim:XML in xml.animation) {
				var name:String = anim.@name;
				_animationMap[name] = new AnimationSet(name, anim.animStart.@value, anim.animEnd.@value);
			}
			
			trace("Finished loading " + count + " animation sets.");
		}
		
		public function getAnimSet(name:String):AnimationSet
		{
			return _animationMap[name] as AnimationSet;
		}
		
		public function hasAnimSet(name:String):Boolean
		{
			return _animationMap[name] != null;
		}
		
		private function xmlLoadedHandler(event:Event):void
		{
			trace("Animation Set Pool has finished loading XML.");
			
			var data:XML = XML(_urlLoader.data);
			parse(data);
			
			// always remove event listener
			_urlLoader.removeEventListener(Event.COMPLETE, xmlLoadedHandler);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}