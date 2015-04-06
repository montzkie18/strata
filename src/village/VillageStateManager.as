package village
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.preloaders.Preloader;
	
	public class VillageStateManager extends EventDispatcher
	{
		public static const STATE_CHANGED : String = "vstate_changed";
		
		
		private var _villageState : VillageState;
		public function get villageState():VillageState {return _villageState;}
		
		private var _previousState : VillageState;
		public function get previousState():VillageState {return _previousState;}
		
		private var _nextState : VillageState;
		
		public function VillageStateManager() {
			_villageState = VillageState.DEFAULT;
			_previousState = VillageState.DEFAULT;
			_nextState = VillageState.DEFAULT;
		}
		
		public function setState(state:VillageState):void {
			if(villageState == state) return;
			
			_previousState = _villageState;
			_villageState = state;
			
			dispatchEvent(new Event(STATE_CHANGED));
		}
		
		public function setStateAndNext(state:VillageState, 
										nextState:VillageState):void {
			_nextState = nextState;
			setState(state);
		}
		
		public function cancelState():void {
			//_nextState = _villageState;
			_villageState = _previousState;
		}
		
		public function nextState():void {
			if (_nextState != VillageState.DEFAULT) {
				setState(_nextState);
				_nextState = VillageState.DEFAULT;
			}
		}
	}
}