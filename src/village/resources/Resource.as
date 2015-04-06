package village.resources
{
	import common.Assertions;

	public class Resource
	{
		protected var _name 	: String;
		protected var _amount 	: int;
		protected var _type		: ResourceType;
		
		public function Resource(name:String, type:ResourceType, amount:int) 
		{
			this._amount = amount;
			this._name = name;
			this._type = type;
		}
		
		public function get name()			: String {return _name;}
		public function get value() 		: int {return _amount;}
		public function get type()			: ResourceType {return _type;}	
		
		public function useResource(cost:int):void
		{
			if (_type == ResourceType.POPULATION)
				_amount += cost;
			else
				_amount -= cost;
		}
		
		public function trimExcess(max:int):void
		{
			//Don't trim if there's an excess in population
			if (_type != ResourceType.POPULATION)
				if (_amount > max)
					_amount = max;
		}
		
		public function add(res:int):void 
		{
			_amount += res;
		}
		public function subtract(res:int):void 
		{
			if (res >= _amount)
				_amount = 0;
			else
				_amount -= res;
		}
		
		public function isEnough(res:int):Boolean
		{
			//Always return false for upkeep resources
			if (_type == ResourceType.POPULATION)
				return false;
			else
				return (res <= this._amount); 
		}
		
	}
}