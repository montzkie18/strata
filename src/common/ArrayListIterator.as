package common
{
	import mx.collections.ArrayList;

	public class ArrayListIterator implements IIterator
	{
		private var _list:ArrayList;
		private var _index:int;
		
		public function ArrayListIterator(list:ArrayList)
		{
			_list = list;
			reset();
		}
		
		public function hasNext():Boolean
		{
			return _index < _list.length;
		}
		
		public function next():Object
		{
			return _list.getItemAt(_index++);
		}
		
		public function reset():void
		{
			_index = 0;
		}
	}
}