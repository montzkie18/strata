package village.buildings
{

	import flash.geom.Point;
	
	import village.resources.ResourcePool;

	public class BasicBuilding
	{		
		protected var _id			: String;
		protected var _name			: String;
		protected var _type			: BuildingType;
		protected var _rows			: int;
		protected var _columns		: int;
		protected var _bottomOffset : Number;
		protected var _spriteClass	: String;
		
		protected var _resourceCost : ResourcePool;
		
		public function BasicBuilding(id:String, 
								 name:String, 
								 type:BuildingType, 
								 rows:int, 
								 columns:int, 
								 info:Object,
								 sprite:String)
		{
			_id 				= id;
			_name 				= name;
			_type 				= type;
			_columns			= columns;
			_rows				= rows;
			
			_resourceCost = new ResourcePool(getInt(info["FoodCost"]),
											 getInt(info["WoodCost"]),
											 getInt(info["OreCost"]),
											 getInt(info["PopulationCost"]));
			
			_bottomOffset = 0;
			
			_spriteClass = sprite;
		}
		
		protected function getInt(info:Object):int
		{
			if (info)
				return parseInt(info.toString());
			else
				return 0;
		}
		
		public function get id():String	{return _id;}
		public function set id(value:String):void {_id += "_" + value;}
		public function get buildingName():String	{return _name;}
		public function get type():BuildingType	{return _type;}
		public function get cellRow():int {return _rows;}
		public function get cellColumn():int {return _columns;}
		public function get cost():ResourcePool	{return _resourceCost;}
		public function get bottomOffset():Number {return _bottomOffset;}
		public function get spriteClass():String {return _spriteClass;}
	}
}