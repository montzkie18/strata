package game
{
	import battle.Army;
	import battle.BattleTacticsList;

	public class PlayerModel
	{
		private var _tacticsList:BattleTacticsList;
		private var _name:String;
		
		public function PlayerModel(name:String = "Player")
		{
			_name = name;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set tactics(value:BattleTacticsList):void
		{
			_tacticsList = value;
		}
		
		public function activateOffensiveTactics(army:Army):Array
		{
			if(_tacticsList != null)
				return _tacticsList.activateOffense(army);
			else
				return [];
		}
		
		public function activateDefensiveTactics(army:Army):Array
		{
			if(_tacticsList != null)
				return _tacticsList.activateDefense(army);
			else
				return [];
		}
	}
}