package village
{
	import common.Enum;
	
	public class UpkeepState extends Enum
	{
		public static const NORMAL:UpkeepState = new UpkeepState();
		public static const OVERFLOW:UpkeepState = new UpkeepState();
		
		{
			initEnumConstant(UpkeepState);
		}
	}
}