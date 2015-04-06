package battle
{
	import common.Assertions;
	
	import flash.utils.Dictionary;
	
	import tactics.TacticsInfo;

	public class BattleActionPool implements IActionPool
	{
		private var _actionMap:Dictionary;
		
		public function BattleActionPool()
		{
		}
		
		public function initialize():void 
		{
			_actionMap = new Dictionary(true);
			
			addActionType("dmgBonus", onIncreaseDamage);
			addActionType("defBonus", onIncreaseDefense);
			addActionType("turnDamage", onTurnDamage);
			addActionType("leech", onLeech);
			addActionType("recoil", onRecoil);
		}
		
		public function doAction(info:TacticsInfo, actionReceiver:Object /* Army */):void 
		{
			Assertions.assert(actionReceiver is Army, "BattleActionPool must accept an Army object as action receiver.");
			
			var army:Army = actionReceiver as Army;
			for(var key:Object in _actionMap)
			{
				var actionType:String = String(key);
				if(info.containsKey(actionType)){
					var data:Object = info.get(actionType);
					var action:Function = getActionForType(actionType);
					action(data, army);
				}
			}
		}
		
		private function addActionType(type:String, action:Function):void
		{
			_actionMap[type] = action;
		}
		
		private function getActionForType(type:String):Function
		{
			var action:Function = _actionMap[type];
			if(action != null)
				return action;
			else
				return onWait;	// default is to do nothing
		}
		
		// Start of battle action implementations
		
		public function onWait(data:Object, army:Army):void
		{
			// do nothing
		}
		
		public function onIncreaseDamage(data:Object, army:Army):void
		{
			var damageIncrease:Number = Number(data) / 100;
			army.increaseDamage(damageIncrease);
		} 
		
		public function onIncreaseDefense(data:Object, army:Army):void
		{
			var defenseIncrease:Number = Number(data) / 100;
			army.increaseDefense(defenseIncrease);
		}
		
		public function onTurnDamage(data:Object, army:Army):void
		{
			
		}
		
		public function onLeech(data:Object, army:Army):void
		{
			
		}
		
		public function onRecoil(data:Object, army:Army):void
		{
			
		}
	}
}