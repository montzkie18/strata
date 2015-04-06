package village.buildings
{
	public class ResourceBuilding extends BasicBuilding
	{
		private var _foodIncrease		: int;
		private var _woodIncrease		: int;
		private var _oreIncrease		: int;
		private var _minutesToResUp		: int;
		
		public function ResourceBuilding(id:String, 
										 name:String, 
										 type:BuildingType, 
										 width:int, 
										 length:int, 
										 info:Object,
										 sprite:String)
		{
			super(id, name, type, width, length, info, sprite);
			_foodIncrease 		= getInt(info["FoodIncrease"]);
			_woodIncrease 		= getInt(info["WoodIncrease"]);
			_oreIncrease 		= getInt(info["OreIncrease"]);
			_minutesToResUp 	= getInt(info["MinutesToResUp"]);
		}
		
		public function get foodIncrease():int	{return _foodIncrease;}
		public function get woodIncrease():int	{return _woodIncrease;}
		public function get oreIncrease():int	{return _oreIncrease;}
		public function get minutesToResUp():int{return _minutesToResUp;}
	}
}