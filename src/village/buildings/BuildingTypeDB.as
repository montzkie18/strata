package village.buildings
{
	import br.com.stimuli.loading.BulkLoader;
	
	import common.Factory;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.sampler.NewObjectSample;
	
	import game.ResourceManager;
	
	public class BuildingTypeDB implements IEventDispatcher
	{
		private var _eventDispatcher: EventDispatcher;
		
		//private var xml				: XML;
		private var loader			: URLLoader;
		private var buildingTypes	: Object;
		private var buildingFactory	: Factory;
		
		public function BuildingTypeDB()
		{
			_eventDispatcher = new EventDispatcher();
			loadFactory();
		}
		
		private function loadFactory():void
		{
			buildingFactory = new Factory();
			buildingFactory.addClassType(BuildingType.UNIT_PROD, BasicBuilding);
			buildingFactory.addClassType(BuildingType.MISC, BasicBuilding);
			buildingFactory.addClassType(BuildingType.RESOURCE, ResourceBuilding);
			buildingFactory.addClassType(BuildingType.UPKEEP, UpkeepBuilding);
		}
		
		
		public function load(xmlSource:String):void
		{
			buildingTypes = new Array();
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onXMLLoaded);
			loader.load(new URLRequest(xmlSource));
		}
		
		private function onXMLLoaded(event:Event):void
		{
			trace("Building type list has finished loading XML.");
			
			var data:XML = XML(loader.data);
			parse(data);
			
			// always remove event listener
			loader.removeEventListener(Event.COMPLETE, onXMLLoaded);
		}
		
		//JOJO- ignore this for now.=p
		public function loadXML(xmlSource:String):void
		{
			var assetLoader:BulkLoader = BulkLoader.getLoader(ResourceManager.LOADER_ID_ASSETS_LIST);
			var tempXML:XML = assetLoader.getContent(xmlSource);
			parse(tempXML);
		}
		
		
		private function parse(xml:XML):void
		{
			//loader.removeEventListener(Event.OPEN, processXML);
			//xml = new XML(e.target.data);
			
			for each(var row:XML in xml.row) {
				var info:Object = new Object();
				for each(var data:XML in row.data) {
					info[data.@key] = data.@value.toString();
				}
				
				var id:String = row.@id.toString();
				var name:String = row.@name.toString();
				var type:BuildingType = BuildingType.getTypeByString(row.@type.toString());
				var rows:int = parseInt(row.@rows.toString());
				var columns:int = parseInt(row.@columns.toString())
				var sprite:String = row.@sprite.toString();
				
				buildingTypes[row.@id] = buildingFactory.requestObject(type, id, 
																	   name, type, 
																	   rows, columns, 
																	   info, sprite);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public function getBuildingDataByName(id:String):BasicBuilding
		{
			return buildingTypes[id];
		}
		public function buildingList():Object
		{
			return buildingTypes;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakRef:Boolean = true):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakRef);
		}
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}
		public function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}
		public function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}
		
	}
}