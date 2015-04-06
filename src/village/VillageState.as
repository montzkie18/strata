package village
{
	import common.Enum;
	
	public class VillageState extends Enum
	{
		public static const DEFAULT		: VillageState = new VillageState();
		public static const NORMAL		: VillageState = new VillageState();
		public static const NOTICE		: VillageState = new VillageState();
		public static const BUILD		: VillageState = new VillageState();
		public static const DECO		: VillageState = new VillageState();
		public static const DESTROY		: VillageState = new VillageState();
		public static const BUY			: VillageState = new VillageState();
		public static const MOVE		: VillageState = new VillageState();
		
		{
			initEnumConstant(VillageState);
		}
	}
}