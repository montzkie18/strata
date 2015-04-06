package tactics
{
	import battle.Army;
	import battle.BattleActionPool;
	import battle.IActionPool;
	import battle.IArmyModifier;
	
	import common.Assertions;

	public class BasicTactics implements IArmyModifier
	{
		private var _info:TacticsInfo;
		
		public function BasicTactics(info:TacticsInfo)
		{
			Assertions.assertNotNull(info, "Passed a null tactics info during instantiation of BasicTactics");
			_info = info;
		}
		
		public function activate(actionPool:IActionPool, actionReceiver:Object):Boolean
		{
			var success:Boolean = hasChance();
			if(success){
				actionPool.doAction(_info, actionReceiver);
				if(actionReceiver is Army) {
					var army:Army = actionReceiver as Army;
					trace("***" + _info.getName() + " is activated by " + army.toString() + " ***");
				}
			}
			return success;
		}
		
		public function get type():String
		{
			return _info.getType();
		}
		
		public function get info():TacticsInfo
		{
			return _info;
		}
		
		private function hasChance():Boolean
		{
			var chance:Number = _info.getChance() / 100.0;
			var random:Number = Math.random();
			if(random < chance) {
				return true;
			}else{
				return false;
			}
		}
	}
}