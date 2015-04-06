package village.notices
{
	import common.Enum;
	
	public class NoticeResponseType extends Enum
	{
		public static const EMPTY		: NoticeResponseType = new NoticeResponseType();
		public static const OK			: NoticeResponseType = new NoticeResponseType();
		public static const OKCANCEL	: NoticeResponseType = new NoticeResponseType();
		public static const YESNO		: NoticeResponseType = new NoticeResponseType();
		
		{
			initEnumConstant(NoticeResponseType);
		}
	}
}