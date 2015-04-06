package battle
{
	public class BattleSimulator
	{
		private var _armies:Vector.<Army>;
		private var _status:BattleStatusType;
		
		private var _offensiveIndex:int;
		private var _defensiveIndex:int;
		
		public function BattleSimulator(offensive:Army, defensive:Army)
		{
			_armies = new Vector.<Army>();
			_armies.push(offensive);
			_armies.push(defensive);
			
			_status = BattleStatusType.PENDING;
		}
		
		public function simulate(maxTurns:int = 20):BattleEventQueue
		{
			trace("**************************");
			trace("START OF BATTLE SIMULATION");
			trace("**************************");
			
			_offensiveIndex = 0;
			_defensiveIndex = 1;
			
			trace(_armies[_offensiveIndex].toString());
			trace("******      VS      ******");
			trace(_armies[_defensiveIndex].toString());
			trace("**************************");
			
			var eventQueue:BattleEventQueue = new BattleEventQueue();
			var turnIndex:int = 0;
			for(turnIndex = 0; turnIndex < maxTurns; turnIndex++)
			{
				var offense:Army = _armies[_offensiveIndex];
				var defense:Army = _armies[_defensiveIndex];
				
				var offensiveTactics:Array = offense.setOffensiveTactics();
				var defensiveTactics:Array = defense.setDefensiveTactics();
				
				// simulate attack
				var attackData:Object = offense.attack(defense);
				var damage:int = attackData["damage"];
				var recoil:int = attackData["recoil"];
				
				eventQueue.enqueue(new BattleTurn(offensiveTactics, defensiveTactics, damage, recoil));
				
				trace(offense.toString() + " has attacked " + defense.toString());
				
				if(offense.hasSurrendered() || defense.hasSurrendered())
				{
					break;
				}
				
				offense.removeTacticEffects();
				defense.removeTacticEffects();
				
				switchTurns();
			}
			
			trace("Battle finished in " + (turnIndex + 1) + " turns.");
			trace("**************************");
			trace("*END OF BATTLE SIMULATION*");
			trace("**************************");
			
			checkBattleResults();
			
			return eventQueue;
		}
		
		public function get status():BattleStatusType
		{
			return _status;
		}
		
		private function checkBattleResults():void
		{
			var offense:Army = _armies[0];
			var defense:Army = _armies[1];
			
			if(offense.hasSurrendered() && defense.hasSurrendered()){
				_status = BattleStatusType.DRAW;
			}else if(offense.hasSurrendered()){
				_status = BattleStatusType.LOST;
			}else if(defense.hasSurrendered()){
				_status = BattleStatusType.WON;
			}else{
				_status = BattleStatusType.DRAW;
			}
		}
		
		private function switchTurns():void
		{
			_offensiveIndex++;
			if(_offensiveIndex >= 2) {
				_offensiveIndex = 0;
			}
			
			_defensiveIndex = _offensiveIndex + 1;
			if(_defensiveIndex >= 2) {
				_defensiveIndex = 0;
			}
		}
		
	}
}