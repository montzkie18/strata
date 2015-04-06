package equipment
{
	import common.DataMap;
	
	public class EquipmentInfo extends DataMap
	{
		public function EquipmentInfo(data:Object)
		{
			super(data);
		}
		
		public function getId():String
		{
			return get("id") as String;
		}
		
		public function getName():String
		{
			return get("name") as String;
		}
		
		public function getType():String
		{
			return get("type") as String;
		}
	}
}