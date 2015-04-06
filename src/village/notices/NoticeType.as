package village.notices
{
	import common.Enum;
	
	public class NoticeType extends Enum
	{
		public static const BASIC_NOTICE	: NoticeType = new NoticeType();
		
		{
			initEnumConstant(NoticeType);
		}
	}
}