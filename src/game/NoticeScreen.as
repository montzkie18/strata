package game
{
	import flash.events.Event;
	
	import village.notices.BasicNotice;
	import village.notices.NoticeResponseType;
	import village.notices.NoticeType;

	public class NoticeScreen extends BasicScreen
	{
		private var noticeStack : Vector.<BasicNotice>;
		
		private var _onScreenCount : uint;
		public function get isLocked():Boolean {return (_onScreenCount > 0);}
	
		public function NoticeScreen(game:MainGame, canvas:MainCanvas) {
			super(game, canvas);
		}
		

		protected override function initialize(event:Event = null):void {
			super.initialize(event);
			noticeStack = new Vector.<BasicNotice>;
			this.mouseEnabled = false;
		}
		
		public override function update(timeElapsedMs:Number):Boolean {
			checkForDispatch();
			return true;
		}
		
		private function checkForDispatch():void {
			if (noticeStack.length > 0) {
				var newNotice:BasicNotice = noticeStack.shift();
				this.addChild(newNotice);
			}
		}
		
		public function dispatchNotice(newNotice:BasicNotice):void {
			newNotice.addEventListener(BasicNotice.EXIT, onNoticeClose);
			newNotice.addEventListener(BasicNotice.CANCEL, onNoticeClose);
			newNotice.addEventListener(BasicNotice.NO, onNoticeClose);
			newNotice.x = (MainCanvas.STAGE_WIDTH/2) - (newNotice.width/2);
			newNotice.y = (MainCanvas.STAGE_HEIGHT/2) - (newNotice.height/2);
			noticeStack.push(newNotice);
			this.mouseEnabled = true;
			_onScreenCount++;
		}
		
		private function onNoticeClose(e:Event):void {
			if (noticeStack.length == 0) {
				this.mouseEnabled = false;
				_onScreenCount--;
			}
			
			removeChild(e.currentTarget as BasicNotice);
		}
	}
}