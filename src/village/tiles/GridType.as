package village.tiles
{
	import common.Enum;

	public class GridType extends Enum
	{
		public static const ORTHOGRAPHIC:GridType = new GridType();
		public static const ISOMETRIC:GridType = new GridType();
		
		{
			initEnumConstant(GridType);
		}
	}
}