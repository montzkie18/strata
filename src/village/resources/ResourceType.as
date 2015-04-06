package village.resources
{
	import common.Enum;
	
	public class ResourceType extends Enum
	{
		public static const FOOD		:ResourceType = new ResourceType();
		public static const WOOD		:ResourceType = new ResourceType();
		public static const ORE			:ResourceType = new ResourceType();
		public static const POPULATION	:ResourceType = new ResourceType();
		
		{
			initEnumConstant(ResourceType);
		}
	}
}