package game
{
	import equipment.EquipmentPool;
	
	import animation.AnimationSetPool;
	import animation.MovieClipDataPool;
	
	import battle.AnimationActionPool;
	import battle.BattleActionPool;
	
	import br.com.stimuli.loading.BulkLoader;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import mithril.CTimeManager;
	
	import tactics.TacticsInfoDB;
	
	import village.PlayerResources;
	import village.buildings.BuildingTypeDB;
	import village.resources.Resource;

	public class MainGame extends EventDispatcher
	{
		public static const STATE_CHANGE:String = "statechange";
		
		private var _canvas:MainCanvas;
		private var _state:GameState;
		
		private var _timeDeltaMs:Number;		
		private var _previousTimeMs:Number;
		private var _currentTimeMs:Number;
		
		private var _resourcePool:PlayerResources;
		public function get resourcePool():PlayerResources { return _resourcePool; }

		private var _buildingTypePool:BuildingTypeDB;
		public function get buildingTypePool():BuildingTypeDB { return _buildingTypePool; }
		
		private var _tacticsInfoPool:TacticsInfoDB;
		public function get tacticsInfoPool():TacticsInfoDB { return _tacticsInfoPool; }
		
		private var _movieClipDataPool:MovieClipDataPool;
		public function get movieClipDataPool():MovieClipDataPool { return _movieClipDataPool; }
		
		private var _soldierAnimationPool:AnimationSetPool;
		public function get soldierAnimationPool():AnimationSetPool { return _soldierAnimationPool; }
		
		private var _battleActionPool:BattleActionPool;
		public function get battleActionPool():BattleActionPool { return _battleActionPool; }
		
		private var _animationActionPool:AnimationActionPool;
		public function get animationActionPool():AnimationActionPool { return _animationActionPool; }
		
		public function MainGame(canvas:MainCanvas)
		{
			_canvas = canvas;
			_timeDeltaMs = 0;
			_previousTimeMs = 0;
			_currentTimeMs = 0;
			
			_resourcePool = new PlayerResources();
			_buildingTypePool = new BuildingTypeDB();
			_tacticsInfoPool = new TacticsInfoDB();
			_movieClipDataPool = new MovieClipDataPool();
			_soldierAnimationPool = new AnimationSetPool();
			_battleActionPool = new BattleActionPool();
			_animationActionPool = new AnimationActionPool();
			
			ResourceManager.loadAssetList(this);
		}
		
		public function initialize():void
		{
			_canvas.addEventListener(Event.ENTER_FRAME, updateState, false, 0, true);
			
			EquipmentPool.load(ResourceManager.getAsset("XML_ITEM_LIST"));
		}
		
		/*
		* STATE Handling Methods
		*/ 
		
		public function startGame():void 
		{
			changeState(GameState.INITILIZATION);
		}
		
		public function changeState(state:GameState):void
		{
			if(_state == state) return;
			
			_state = state;
			switch(_state)
			{
				case GameState.INITILIZATION:
					_canvas.pushScreen(new LoadingScreen(this, _canvas));
					break;
				
				case GameState.IN_VILLAGE:
					_canvas.clearScreenStack();
					_canvas.pushScreen(new GameScreen(this, _canvas));
					break;
				
				case GameState.IN_BATTLE:
					_canvas.clearScreenStack();
					_canvas.pushScreen(new BattleScreen(this, _canvas));
					break;
				
				case GameState.LOADING:
					break;
				
				case GameState.RUNNING:
					break;
			}
			
			dispatchEvent(new Event(STATE_CHANGE));
		}
		
		public function updateState(event:Event):void
		{
			_currentTimeMs = getTimer();
			_timeDeltaMs = _currentTimeMs - _previousTimeMs;
			
			_canvas.updateScreen(_timeDeltaMs);
			
			_previousTimeMs = _currentTimeMs;
		}
		
		public function get state():GameState 
		{
			return _state;
		}
	}
}