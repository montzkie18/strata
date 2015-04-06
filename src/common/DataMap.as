package common
{
	public class DataMap
	{
		private var _data:Object;
		
		public function DataMap(data:Object)
		{
			_data = data;
		}
		
		public function get(key:String):Object
		{
			return _data[key];
		}
		
		public function getString(key:String):String
		{
			var string:Object = get(key);
			if(string != null)
				return String(string);
			else
				return "";
		}
		
		public function getNumber(key:String):Number
		{
			var num:Object = get(key);
			if(num != null)
				return Number(num);
			else
				return 0;
		}
		
		public function containsKey(key:String):Boolean
		{
			if(_data[key] != null)
				return true;
			else
				return false;
		}
	}
}