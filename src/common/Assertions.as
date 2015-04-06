package common
{
	public final class Assertions {
		
		public static function assert(expression:Boolean, errmsg:String):void 
		{
			if(!expression) {
				var msg:String = "";
				msg += "******************\n";
				msg += "**ASSERT FAILED!**\n";
				msg += "******************\n";
				msg += "MSG: " + errmsg + "\n";
				msg += "STACKTRACE: " + getStackTrace() + "\n";
				trace(msg);
			}
		}
		
		public static function assertNotNull(object:Object, errmsg:String):void
		{
			assert(object != null, errmsg);
		}
		
		public static function getStackTrace():String 
		{
			var stack:String = "";
			try{
				throw new Error();
			}catch(e:Error) {
				stack = e.getStackTrace();
			}
			return stack;
		}
	}
}