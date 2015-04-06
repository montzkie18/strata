package equipment
{
	public class EquipmentPool
	{
		private static var _itemList:Vector.<Equipment>;
		
		public function EquipmentPool()
		{
			
		}
		
		/*
		public static function load(objects:Object):void
		{
			for each(var object:Object in objects)
			{
				
				for each(var data:Object in object.data)
				{
					
				}
			}
		}
		*/
		
		public static function load(equipXML:XML):void
		{
			//var xml:XML = ResourceManager.getAsset("XML_ITEM_LIST");
			var _itemList:Vector.<Equipment> = new Vector.<Equipment>;//(size, );
			
			if (equipXML)
			{
				var list:XMLList = equipXML.child("item");
				
				var i:int = 0;
				var j:int = 0;
				for (i = 0; i < list.length(); i++)
				{
					var dataInfo:Object = new Object()
					var tempXML:XML = list[i];
					
					dataInfo["id"] = tempXML.attribute("id");
					dataInfo["name"] = tempXML.attribute("name");
					dataInfo["type"] = tempXML.attribute("type");
					dataInfo["swf"] = tempXML.attribute("swf");
					
					
					
					//trace("\nName: " +tempXML.attribute("name"));
					var attribList:XMLList = tempXML.child("attrib");
					for (j = 0; j < attribList.length(); j++)
					{
						var attribXML:XML = attribList[j];
						dataInfo[attribXML.attribute("key")] = attribXML.attribute("value");
						//trace(">> " + attribXML.attribute("key") + ": " + attribXML.attribute("value"));
					}
					
					var equipInfo:EquipmentInfo = new EquipmentInfo(dataInfo);
					_itemList.push(new Equipment(equipInfo));
				}
			}
			
			for each (var equip:Equipment in _itemList)
			{
				trace(" >> " + equip.info.get("swf"));
				
			}
		}
		
	}
}