package equipment
{
	import common.Enum;
	
	public class EquipmentType extends Enum
	{
		public static const Head:EquipmentType = new EquipmentType();
		public static const Neck:EquipmentType = new EquipmentType();
		public static const Hands:EquipmentType = new EquipmentType();
		public static const Ring:EquipmentType = new EquipmentType();
		public static const Body:EquipmentType = new EquipmentType();
		public static const Waist:EquipmentType = new EquipmentType();
		public static const Legs:EquipmentType = new EquipmentType();
		public static const Feet:EquipmentType = new EquipmentType();
		public static const Weapon:EquipmentType = new EquipmentType();
		public static const Shield:EquipmentType = new EquipmentType();
		
		{
			initEnumConstant(EquipmentType);
		}
	}
}