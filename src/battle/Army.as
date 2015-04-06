package battle
{	
	import game.PlayerModel;

	import mx.collections.ArrayList;

	public class Army
	{
		public static const HEALTH_PER_SOLDIER:int = 100;
		public static const DAMAGE_PER_SOLDIER:int = 10;
		private const RECOIL_PERCENTAGE:Number = 0.1;
		
		private var _player:PlayerModel;
		private var _soldierCount:int;
		
		private var _baseDamage:int;
		private var _damage:int;
		private var _health:int;
		private var _defense:Number;
		
		private var _isInvincible:Boolean;
		private var _isRanged:Boolean;
		
		public function Army(player:PlayerModel, soldierCount:int)
		{
			_player = player;
			_soldierCount = soldierCount;
			_baseDamage = soldierCount;
			_health = soldierCount * HEALTH_PER_SOLDIER;
			removeTacticEffects();
		}
		
		public function removeTacticEffects():void
		{
			_damage = _soldierCount * DAMAGE_PER_SOLDIER;
			_defense = 0;
			
			_isInvincible = false;
			_isRanged = false;
		}
		
		public function increaseDamage(percentage:Number):void
		{
			_damage = _damage + (_damage * percentage);
		}
		
		public function increaseDefense(amount:Number):void
		{
			_defense = amount;
		}
		
		public function activateInvincibility():void
		{
			_isInvincible = true;
		}
		
		public function activateRangeAttack():void
		{
			_isRanged = true;
		}
		
		public function setOffensiveTactics():Array
		{
			return _player.activateOffensiveTactics(this);
		}
		
		public function setDefensiveTactics():Array
		{
			return _player.activateDefensiveTactics(this);
		}
		
		public function attack(opponent:Army):Object
		{
			var result:Object = new Object();
			
			if(_isInvincible){
				result["damage"] = 0;
				result["recoil"] = 0;
			}else {
				result["damage"] = opponent.damage(_damage);
				if(_isRanged) {
					result["recoil"] = 0;
				}else{
					result["recoil"] = _damage * RECOIL_PERCENTAGE;
					recoilDamage();
				}
			}

			return result;
		}
		
		protected function damage(amount:int):int
		{
			// clamp defense to 0 to avoid adding health if Defense is greater than Damage
			var damage:int = Math.max(0, amount - _defense);
			
			_health = _health - damage;
			// clamp current health to minimum of 0
			_health = Math.max(0, _health);	
			
			_soldierCount = Math.ceil(_health / HEALTH_PER_SOLDIER);
			return damage;
		}
		
		protected function recoilDamage():void
		{
			damage(_damage * RECOIL_PERCENTAGE);
		}
		
		public function hasSurrendered():Boolean
		{
			return _soldierCount <= 0;
		}
		
		public function get soldierCount():int
		{
			return _soldierCount;
		}
		
		public function toString():String
		{
			return _player.name + " |Soldiers:" + _soldierCount + "|Health:" + _health + "|";
		}
	}
}