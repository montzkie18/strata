package battle
{
	import tactics.BasicTactics;

	public class BattleTacticsList
	{
		private var _offensiveTactics:Vector.<BasicTactics>;
		private var _defensiveTactics:Vector.<BasicTactics>;
		
		private var _actionPool:BattleActionPool;
		
		public function BattleTacticsList(actionPool:BattleActionPool)
		{
			_actionPool = actionPool;
			
			_offensiveTactics = new Vector.<BasicTactics>();
			_defensiveTactics = new Vector.<BasicTactics>();
		}
		
		public function addTactic(tactic:BasicTactics):void
		{
			if(tactic.type == "Offensive") {
				_offensiveTactics.push(tactic);
			}else if(tactic.type == "Passive"){
				_defensiveTactics.push(tactic);
			}
		}
		
		public function removeTactic(tactic:BasicTactics):void
		{
			if(tactic.type == "Offensive") {
				remove(_offensiveTactics, tactic);
			}else if(tactic.type == "Passive") {
				remove(_defensiveTactics, tactic);
			}
		}
		
		public function activateOffense(army:Army):Array /* tactics id (string) */
		{
			var activatedTactics:Array = [];
			var count:int = _offensiveTactics.length;
			for(var i:int=0; i<count; i++)
			{
				var tactic:BasicTactics = _offensiveTactics[i];
				var success:Boolean = tactic.activate(_actionPool, army);
				if(success) {
					activatedTactics.push(tactic.info.getID());
				}
			}
			return activatedTactics;
		}
		
		public function activateDefense(army:Army):Array /* tactics id (string) */
		{
			var activatedTactics:Array = [];
			var count:int = _defensiveTactics.length;
			for(var i:int=0; i<count; i++)
			{
				var tactic:BasicTactics = _defensiveTactics[i];
				var success:Boolean = tactic.activate(_actionPool, army);
				if(success) {
					activatedTactics.push(tactic.info.getID());
				}
			}
			return activatedTactics;
		}
		
		private function remove(list:Vector.<BasicTactics>, tactic:BasicTactics):void
		{
			var index:int = list.indexOf(tactic);
			if(index >= 0) {
				list.splice(index, 1);
			}
		}
	}
}