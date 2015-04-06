package village.buildings
{
	public class UpkeepBuilding extends BasicBuilding
	{
		private var _storageUpkeep		: int;
		private var _populationUpkeep	: int;
		
		public function UpkeepBuilding(id:String, 
									   name:String, 
									   type:BuildingType, 
									   width:int, 
									   length:int, 
									   info:Object, 
									   sprite:String)
		{
			super(id, name, type, width, length, info, sprite);
			_storageUpkeep 		= getInt(info["StorageIncrease"]);
			_populationUpkeep 	= getInt(info["PopulationIncrease"]);
		}
		
		public function get storageUpkeep():int	{return _storageUpkeep;}
		public function get populationUpkeep():int	{return _populationUpkeep;}
	}
}