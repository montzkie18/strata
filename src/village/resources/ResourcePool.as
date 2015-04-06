package village.resources
{
	public class ResourcePool
	{
		private var _food		: Resource;
		private var _wood		: Resource;
		private var _ore		: Resource;
		private var _population	: Resource;
		
		public function get food():int {return _food.value};
		public function get wood():int {return _wood.value};
		public function get ore():int {return _ore.value};
		public function get population():int {return _population.value};
		
		public function ResourcePool(food:int=0, wood:int=0, ore:int=0, population:int=0)
		{
			//ID and String added for a later localization
			_food 		= new Resource("Food",ResourceType.WOOD,food);;
			_wood 		= new Resource("Wood",ResourceType.FOOD,wood);
			_ore  		= new Resource("Ore",ResourceType.ORE,ore);
			_population = new Resource("Population",ResourceType.POPULATION,population);
		}
		
		public function trimExcessResource(maxstorage:int):void
		{
			_food.trimExcess(maxstorage);
			_wood.trimExcess(maxstorage);
			_ore.trimExcess(maxstorage);
		}
		
		public function isEnough(res:ResourcePool):Boolean
		{
			return (this._food.isEnough(res.food) &&
					this._wood.isEnough(res.wood) &&
					this._ore.isEnough(res.ore))
		}

		public function useResources(res:ResourcePool):void
		{
			_food.useResource(res.food);
			_wood.useResource(res.wood);
			_ore.useResource(res.ore);
			_population.useResource(res.population);
		}
		
		public function addResource(res:ResourcePool):void
		{
			_food.add(res.food);
			_wood.add(res.wood);
			_ore.add(res.ore);
		}
		
		public function addPopulation(amount:int):void
		{
			_population.useResource(amount);
		}
		
		public function decreasePopulation(amount:int):void
		{
			_population.subtract(amount);
		}
	}
}