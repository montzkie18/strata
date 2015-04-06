package village
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import game.BasicScreen;
	
	import village.buildings.BasicBuilding;
	import village.buildings.BuildingInfo;
	import village.buildings.BuildingSprite;
	import village.buildings.BuildingType;
	import village.buildings.ResourceBuilding;
	import village.buildings.UpkeepBuilding;
	import village.resources.ResourcePool;
	import village.tiles.Tile;

	public class PlayerResources extends EventDispatcher
	{
//		public static const BUILDING_CONSTRUCTED:String = "building_constructed";
		public static const RESOURCE_CHANGED:String = "resources_changed";
		
		//private var _idkey		: int;
		
		private var _resources	: ResourcePool;
		private var _storage	: int;
		private var _upkeep		: int;
		private var _buildings	: Vector.<BuildingInfo>;
		
		private var _upkeepState	: UpkeepState;
		
		public function PlayerResources() {
			_buildings = new Vector.<BuildingInfo>();
			_resources = new ResourcePool(1000,1000,1000);
			dispatchEvent(new Event(RESOURCE_CHANGED));
			_upkeepState = UpkeepState.NORMAL;
		}
		
		public function get resources():ResourcePool {return _resources;}
		public function get storage():int {return _storage;}
		public function get upkeep():int {return _upkeep;}
		public function get upkeepState():UpkeepState {return _upkeepState;}
		
		/**
		 * Resource
		 * */
		public function hasEnoughResources(cost:ResourcePool):Boolean {
			return (_resources.isEnough(cost) &&
				(_upkeep - _resources.population) >= cost.population);
		}
		public function hasEnoughUpkeep(cost:int):Boolean {
			return (cost <= (_upkeep - _resources.population));
		}
		public function hasEnoughFood(cost:int):Boolean {
			return (cost <= _resources.food);
		}
		public function hasEnoughWood(cost:int):Boolean {
			return (cost <= _resources.wood);
		}
		public function hasEnoughOre(cost:int):Boolean {
			return (cost <= _resources.ore);
		}
		
		public function addResource(res:ResourcePool):void {
			_resources.addResource(res);
			_resources.trimExcessResource(_storage);
			dispatchEvent(new Event(RESOURCE_CHANGED));
		}
		public function increaseStorage(amount:int):void {
			_storage += amount;
			dispatchEvent(new Event(RESOURCE_CHANGED));
		}
		public function decreaseStorage(amount:int):void {
			_storage -= amount;
			_resources.trimExcessResource(_storage);
			dispatchEvent(new Event(RESOURCE_CHANGED));
		}
		public function increasePopulation(amount:int):void {
			_resources.addPopulation(amount);
			dispatchEvent(new Event(RESOURCE_CHANGED));
		}
		public function decreasePopulation(amount:int):void	{
			_resources.decreasePopulation(amount);
			dispatchEvent(new Event(RESOURCE_CHANGED));
		}
		public function increaseUpkeep(amount:int):void	{
			_upkeep += amount;
			dispatchEvent(new Event(RESOURCE_CHANGED));
			updateUpkeepState();
		}
		public function decreaseUpkeep(amount:int):void	{
			if (amount > _upkeep)
				_upkeep = 0;
			else
				_upkeep -= amount;
			dispatchEvent(new Event(RESOURCE_CHANGED));
			updateUpkeepState();
		}
		
		private function updateUpkeepState():void {
			if (_resources.population <= _upkeep)
				_upkeepState = UpkeepState.NORMAL;
			else
				_upkeepState = UpkeepState.OVERFLOW;
		}
		
		/**
		 * Building methods
		 * */
		public function construct(newBuilding:BuildingInfo, 
								  position:Tile):void {
			if (!hasEnoughResources(newBuilding.building.cost))
				return;
			
			var tempBuilding:BuildingInfo = newBuilding;
			
			_buildings.push(tempBuilding);
			//_buildings[_buildings.length - 1].id = _idkey++.toString();
			_resources.useResources(newBuilding.building.cost);
			
			if (newBuilding.building.type == BuildingType.RESOURCE)
				resourceBuildingCreated(newBuilding.building as ResourceBuilding);
			else if (newBuilding.building.type == BuildingType.UPKEEP)
				upkeepBuildingCreated(newBuilding.building as UpkeepBuilding);
			
			dispatchEvent(new Event(RESOURCE_CHANGED));
		}
		public function destroy(selectedBuilding:BuildingInfo):void {
			for (var i:int = 0; i < _buildings.length; i++) {
				if (_buildings[i].tileIndex == selectedBuilding.tileIndex) {
					
					switch (_buildings[i].building.type) {
						case BuildingType.RESOURCE:
							resourceBuildingDestroyed(_buildings[i].building as ResourceBuilding);
							break;
						case BuildingType.UPKEEP:
							upkeepBuildingDestroyed(_buildings[i].building as UpkeepBuilding);
							break;
					}
						
					_buildings.splice(i, 1);
				}
			}
		}
		private function resourceBuildingCreated(newBuilding:ResourceBuilding):void	{
			//return;
		}
		private function upkeepBuildingCreated(newBuilding:UpkeepBuilding):void	{
			increaseUpkeep(newBuilding.populationUpkeep);
			increaseStorage(newBuilding.storageUpkeep);
		}
		
		private function resourceBuildingDestroyed(oldBuilding:ResourceBuilding):void {
			//return
		}
		private function upkeepBuildingDestroyed(oldBuilding:UpkeepBuilding):void {
			decreaseUpkeep(oldBuilding.populationUpkeep);
			decreaseStorage(oldBuilding.storageUpkeep);
		}
	}
}