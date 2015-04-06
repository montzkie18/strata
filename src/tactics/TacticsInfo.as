package tactics
{
	import common.DataMap;

	public class TacticsInfo extends DataMap
	{
		
		public function TacticsInfo(data:Object)
		{
			super(data);
		}
		
		public function getID():String
		{
			return getString("id");
		}
		
		public function getName():String
		{
			return getString("name");
		}
		
		public function getType():String
		{
			return getString("type");
		}
		
		public function getRace():String
		{
			return getString("race");
		}
		
		public function getChance():Number
		{
			return getNumber("chance");
		}
	}
}