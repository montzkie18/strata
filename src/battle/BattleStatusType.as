package battle
{
	import common.Enum;
	
	public class BattleStatusType extends Enum
	{
		
		public static const PENDING:BattleStatusType = new BattleStatusType();
		public static const WON:BattleStatusType = new BattleStatusType();
		public static const LOST:BattleStatusType = new BattleStatusType();
		public static const DRAW:BattleStatusType = new BattleStatusType();
		
		{
			initEnumConstant(BattleStatusType);
		}
	}
}