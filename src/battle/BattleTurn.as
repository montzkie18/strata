package battle
{
	public class BattleTurn
	{
		private var _offensiveTactics:Array;
		private var _defensiveTactics:Array;
		private var _damage:int;
		private var _recoil:int;
		
		public function BattleTurn(offensiveTactics:Array, defensiveTactics:Array, damage:int, recoil:int)
		{
			_offensiveTactics = offensiveTactics;
			_defensiveTactics = defensiveTactics;
			_damage = damage;
			_recoil = recoil;
		}
		
		public function toString():String
		{
			var result:String = "";
			
			result += "off:";
			var i:int = 0;
			var length:int = _offensiveTactics.length;
			for(i = 0; i < length; i++) 
			{
				result += _offensiveTactics[i] as String;
				if(i != length - 1)
					result += ',';
			}
			
			result += "|def:";
			i = 0;
			length = _defensiveTactics.length;
			for(i = 0; i < length; i++) 
			{
				result += _defensiveTactics[i] as String;
				if(i != length - 1)
					result += ',';
			}
			
			result += "|dmg:" + _damage;
			result += "|rec:" + _recoil;
			
			return result;
		}
		
		public function get offense():Array { return _offensiveTactics; }
		public function get defense():Array { return _defensiveTactics; }
		public function get damage():int { return _damage; }
		public function get recoil():int { return _recoil; }
	}
}