package village.buildings
{
	import common.Enum;
	
	public class BuildingType extends Enum
	{
		public static const UPKEEP		: BuildingType = new BuildingType();
		public static const RESOURCE	: BuildingType = new BuildingType();
		public static const UNIT_PROD	: BuildingType = new BuildingType();
		public static const MISC		: BuildingType = new BuildingType();
		
		{
			initEnumConstant(BuildingType);
		}
		
		public static function getTypeByString(type:String):BuildingType
		{
			switch (type) {
				case "Upkeep":
					return UPKEEP;
				case "Resource":
					return RESOURCE;
				case "UnitProd":
					return UNIT_PROD;
				case "Misc":
					return MISC;
				default:
					return new BuildingType();
			}
		}
	}
}