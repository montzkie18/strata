package equipment
{
	import battle.Army;
	import battle.BattleActionPool;
	import battle.IActionPool;
	import battle.IArmyModifier;
	
	public class Equipment implements IArmyModifier
	{
		private var _info:EquipmentInfo;
		private var _type:EquipmentType;
		
		public function Equipment(info:EquipmentInfo)
		{
			_info = info;
			_type = EquipmentType[info.getType()];
		}
		
		public function activate(actionPool:IActionPool, actionReceiver:Object):Boolean
		{
			trace(_info.getName() + " item is activated.");
			return true;
		}
		
		public function get type():EquipmentType
		{
			return _type;
		}
		
		public function get info():EquipmentInfo
		{
			return _info;
		}
	}
}