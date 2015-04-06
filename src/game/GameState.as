package game
{
	import common.Enum;

	public class GameState extends Enum
	{
		public static const INITILIZATION:GameState = new GameState();
		public static const IN_VILLAGE:GameState = new GameState();
		public static const IN_BATTLE:GameState = new GameState();
		public static const LOADING:GameState = new GameState();
		public static const RUNNING:GameState = new GameState();
		
		{
			initEnumConstant(GameState);
		}
	}
}