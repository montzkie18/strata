package battle
{
	import common.ArrayListIterator;
	import common.IIterator;
	
	import mx.collections.ArrayList;

	public class BattleEventQueue
	{
		private var _eventQueue:ArrayList;
		
		public function BattleEventQueue()
		{
			_eventQueue = new ArrayList();
		}
		
		public function load():void
		{
			// TODO! load battle events from database
		}
		
		public function enqueue(turn:BattleTurn):void
		{
			_eventQueue.addItem(turn);
		}
		
		public function get iterator():IIterator
		{
			return new ArrayListIterator(_eventQueue);
		}

	}
}