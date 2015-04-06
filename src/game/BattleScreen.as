package game
{			
	import animation.AnimatedImage;
	import animation.MovieClipData;
	import animation.MovieClipDataPool;
	import animation.TextAnimManager;
	
	import battle.Army;
	import battle.ArmyView;
	import battle.BattleActionPool;
	import battle.BattleAnimationManager;
	import battle.BattleEventQueue;
	import battle.BattleSimulator;
	import battle.BattleTacticsList;
	import battle.BattleTurn;
	import battle.HealthBar;
	import battle.units.BasicUnit;
	
	import caurina.transitions.Tweener;
	
	import common.IIterator;
	import common.Image;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mithril.CInputKeys;
	
	import tactics.BasicTactics;
	import tactics.TacticsInfoDB;

	public class BattleScreen extends BasicScreen
	{
		// lists all the events that transpired in battle
		private var _eventQueue:BattleEventQueue;
		
		private var _manager:BattleAnimationManager;
		
		// contains all units moving on the screen
		private var _unitsLayer:SortedLayer;
		
		private var _leftArmy:ArmyView;
		private var _rightArmy:ArmyView;
		
		private var _leftBar:HealthBar;
		private var _rightBar:HealthBar;
		
		private var _textManager:TextAnimManager;
		private var _damageFont:TextFormat;
		private var _criticalFont:TextFormat;
		
		private var _loadingScreen:BattleLoadingScreen;
				
		public function BattleScreen(game:MainGame, canvas:MainCanvas)
		{
			super(game, canvas);
		}
		
		protected override function initialize(event:Event=null):void
		{
			super.initialize(event);
			
			initializeScreen();
			initializeBattle();
			loadBattleAnimations();
			
			Tweener.init();
			
			_textManager = new TextAnimManager(this);
		}

		private function initializeBattle():void
		{
			// This is where you should load all army variables
			// from the database
			var actionPool:BattleActionPool = gameClass.battleActionPool;
			var tacticsPool:TacticsInfoDB = gameClass.tacticsInfoPool;
			
			var offensiveTactics:BattleTacticsList = new BattleTacticsList(actionPool);
			offensiveTactics.addTactic(new BasicTactics(tacticsPool.getInfo("CriticalHit")));
			offensiveTactics.addTactic(new BasicTactics(tacticsPool.getInfo("Barkskin")));
			offensiveTactics.addTactic(new BasicTactics(tacticsPool.getInfo("Anger")));
			
			var defensiveTactics:BattleTacticsList = new BattleTacticsList(actionPool);
			defensiveTactics.addTactic(new BasicTactics(tacticsPool.getInfo("Anger")));
			
			var myPlayer:PlayerModel = new PlayerModel("Ranier");
			myPlayer.tactics = offensiveTactics;
			
			var opponent:PlayerModel = new PlayerModel("Enemy");
			opponent.tactics = defensiveTactics;
			
			// Determine if the battle is already simulated from the opponent's side
			// or we are initiating the battle
			simulateBattle(myPlayer, 100, opponent, 100);
		}
		
		private function simulateBattle(player:PlayerModel, playerUnits:int, enemy:PlayerModel, enemyUnits:int):void
		{
			var offensive:Army = new Army(player, playerUnits);
			var defensive:Army = new Army(enemy, enemyUnits);
			
			var simulator:BattleSimulator = new BattleSimulator(offensive, defensive);
			_eventQueue = simulator.simulate(100);
			
			trace("BATTLE is " + simulator.status);
			trace("Offensive has " + offensive.soldierCount + " soldiers left");
			trace("Defensive has " + defensive.soldierCount + " soldiers left");
		}
		
		private function initializeScreen():void
		{
			_leftBar = new HealthBar(10000, true);
			_leftBar.x = 10;
			_leftBar.y = 50;
			_leftBar.width = 350;
			_leftBar.height = 20;
			_leftBar.redraw();
			addChild(_leftBar);
			
			_rightBar = new HealthBar(10000, false);
			_rightBar.x = MainCanvas.STAGE_WIDTH - 10 - 350;
			_rightBar.y = 50;
			_rightBar.width = 350;
			_rightBar.height = 20;
			_rightBar.redraw();
			addChild(_rightBar);
			
			_damageFont = new TextFormat("Arial", 20, 0xFFFF1100, true);
			_criticalFont = new TextFormat("Calibri", 32, 0xFFFF0000, true);
			
			clearScreen(0xFF888888);
			
			_unitsLayer = new SortedLayer();
			_unitsLayer.x = MainCanvas.STAGE_WIDTH / 2;
			addChild(_unitsLayer);
		}
		
		private function loadBattleAnimations():void
		{
			_loadingScreen = new BattleLoadingScreen(gameClass, canvas);
			_loadingScreen.addEventListener(Event.COMPLETE, startAnimation);
			canvas.pushScreen(_loadingScreen);
		}
		
		private function startAnimation(event:Event = null):void
		{
			var animationPool:MovieClipDataPool = gameClass.movieClipDataPool;
			var hero:MovieClipData = animationPool.getClip("hero");
			var soldier:MovieClipData = animationPool.getClip("soldier");
			
			_leftArmy = new ArmyView(true, gameClass.soldierAnimationPool, _unitsLayer);
			_leftArmy.setSoldiers(soldier, 100);
			_leftArmy.setHeroAnimation(hero);
			
			_rightArmy = new ArmyView(false, gameClass.soldierAnimationPool, _unitsLayer);
			_rightArmy.setSoldiers(soldier, 100);
			_rightArmy.setHeroAnimation(hero);
			
			_manager = new BattleAnimationManager(this, gameClass.tacticsInfoPool, _eventQueue);
			_manager.start(gameClass.animationActionPool, _leftArmy, _rightArmy);
		}
		
		public override function destroy():void
		{
			
		}
		
		public override function update(timeElapsedMs:Number):Boolean
		{
			_unitsLayer.sortObjects();
			_manager.update(timeElapsedMs);
			_leftArmy.update(timeElapsedMs);
			_rightArmy.update(timeElapsedMs);
			return true;
		}
		
		public override function onMouseDown(pt:Point):Boolean
		{
			return true;
		}
		
		public override function onKeyDown():Boolean
		{
			return true;
		}
		
		public function showDamageEffects(damage:Number, isLeft:Boolean, isCritical:Boolean):void
		{
			if(isLeft){
				_leftBar.reduce(damage);
				_leftBar.redraw();
			}else{
				_rightBar.reduce(damage);
				_rightBar.redraw();
			}
			
			addDamageText(damage.toString(), isLeft, isCritical);
		}
		
		private function addDamageText(damage:String, isLeft:Boolean, isCritical:Boolean):void
		{
			var spawnX:Number = 210 + (isLeft ? 0 : 320);
			var spawnY:Number = 100;
			
			_textManager.textFormat = isCritical ? _criticalFont : _damageFont;
			_textManager.spawnTextAnimation("-" + damage, spawnX, spawnY);
		}
	}
}