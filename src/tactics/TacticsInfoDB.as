package tactics
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import mx.core.INavigatorContent;
	import mx.events.EventListenerRequest;

	public class TacticsInfoDB extends EventDispatcher
	{		
		private var _infoMap:Dictionary;
		
		private var _urlLoader:URLLoader;
		
		public function TacticsInfoDB()
		{
			
		}
		
		public function load(source:String):void
		{
			var request:URLRequest = new URLRequest(source);
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onXMLLoaded);
			_urlLoader.load(request);
		}
		
		public function parse(xml:XML):void 
		{
			_infoMap = new Dictionary(true);
			
			var count:uint = 0;
			for each(var row:XML in xml.row) {
				var id:String = row.@id;
				var info:Object = new Object();
				info["id"] = id;
				info["name"] = row.@name;
				info["race"] = row.@race;
				info["type"] = row.@type;
				for each(var data:XML in row.data) {
					info[data.@key] = data.@value;
				}
				
				if(id != null) {
					_infoMap[id] = new TacticsInfo(info);
					count++;
				}else{
					trace("Unable to load tactics of type " + id + ". Type unknown.");
				}
			}
			trace("Finished loading " + count + " tactics.");
		}
		
		public function getInfo(id:String):TacticsInfo
		{
			return _infoMap[id] as TacticsInfo;
		}
		
		private function onXMLLoaded(event:Event):void
		{
			trace("Tactics Pool has finished loading XML.");
			
			var data:XML = XML(_urlLoader.data);
			parse(data);
			
			// always remove event listener
			_urlLoader.removeEventListener(Event.COMPLETE, onXMLLoaded);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}