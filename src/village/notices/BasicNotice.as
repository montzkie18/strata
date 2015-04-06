package village.notices
{
	import Assets.CancelButtonText;
	import Assets.ExitButton;
	import Assets.NoButtonText;
	import Assets.NoticeBackground;
	import Assets.OkayButtonText;
	import Assets.YesButtonText;
	
	import common.HudButton;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BasicNotice extends MovieClip
	{
		public static const EXIT : String = "notice_exit";
		public static const OKAY : String = "notice_okay";
		public static const CANCEL : String = "notice_cancel";
		public static const YES : String = "notice_yes";
		public static const NO : String = "notice_no";
		
		private const BOTTOM_OFFSET : int = 100;
		
		private var background : MovieClip;
		private var exitButton : HudButton;
		private var okayButton : HudButton;
		private var cancelButton : HudButton;
		private var yesButton : HudButton;
		private var noButton : HudButton;
		private var noticeResponseType : NoticeResponseType;
		
		public function BasicNotice(width:Number, 
									height:Number, 
									responseType:NoticeResponseType) {
			this.noticeResponseType = responseType;
			
			background = new Assets.NoticeBackground;
			this.background.scaleX = (this.background.width/width);
			this.background.scaleY = (this.background.height/height);
			this.addChild(background);
			
			exitButton = new HudButton(0, 0, new Assets.ExitButton, onExit);
			exitButton.x = background.width - exitButton.width;
			this.addChild(exitButton);
			
			drawResponseButtons(responseType);
		}
		
		private function drawResponseButtons(responseType:NoticeResponseType):void {
			switch (responseType) {
				case NoticeResponseType.EMPTY:
					break;
				case NoticeResponseType.OK:
					drawOkayButton();
					break;
				case NoticeResponseType.OKCANCEL:
					drawOkayButton(false);
					drawCancelButton(false);
					break;
				case NoticeResponseType.YESNO:
					drawYesButton();
					drawNoButton();
					break;
			}
		}
		
		private function drawOkayButton(isCentered:Boolean = true):void {
			okayButton = new HudButton(0, 0, new Assets.OkayButtonText, onOkay);
			okayButton.x = (background.width/2) - (okayButton.width/2);
			if (!isCentered)
				okayButton.x -= okayButton.width;
			okayButton.y = background.height - okayButton.height - BOTTOM_OFFSET;
			this.addChild(okayButton);
		}
		private function drawCancelButton(isCentered:Boolean = true):void {
			cancelButton = new HudButton(0, 0, new Assets.CancelButtonText, onCancel);
			cancelButton.x = (background.width/2) - (cancelButton.width/2);
			if (!isCentered)
				cancelButton.x += cancelButton.width;
			cancelButton.y = background.height - cancelButton.height - BOTTOM_OFFSET;
			this.addChild(cancelButton);
		}
		private function drawYesButton():void {
			yesButton = new HudButton(0, 0, new Assets.YesButtonText, onYes);
			yesButton.x = (background.width/2) - (yesButton.width/2) - yesButton.width;
			yesButton.y = background.height - yesButton.height - BOTTOM_OFFSET;
			this.addChild(yesButton);
		}
		private function drawNoButton():void {
			noButton = new HudButton(0, 0, new Assets.NoButtonText, onNo);
			noButton.x = (background.width/2) - (noButton.width/2) + noButton.width;
			noButton.y = background.height - noButton.height - BOTTOM_OFFSET;
			this.addChild(noButton);
		}
		
		private function onExit(e:Event):void {
			this.dispatchEvent(new Event(EXIT));
		}
		private function onOkay(e:Event):void {
			this.dispatchEvent(new Event(OKAY));
		}
		private function onCancel(e:Event):void {
			this.dispatchEvent(new Event(CANCEL));
		}
		private function onYes(e:Event):void {
			this.dispatchEvent(new Event(YES));
		}
		private function onNo(e:Event):void {
			this.dispatchEvent(new Event(NO));
		}
	}
}