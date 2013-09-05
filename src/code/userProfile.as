package code
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import code.tool.RollTool;
	import flash.events.MouseEvent;
	
	public class userProfile extends MovieClip
	{
		private var strStatus:String = "expand";
		
		public function userProfile()
		{
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			RollTool.setRoll(boardMc);
			boardMc.addEventListener(MouseEvent.CLICK, onClickHandler);
		
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			if (strStatus == "close")
			{
				this.bg.gotoAndPlay("expand");
				strStatus = "expand";
			}
		}
		
		public function open()
		{
			this.bg.gotoAndPlay("expand");
			strStatus = "expand";
		}
		
		public function close()
		{
			if (strStatus == "expand")
			{
				this.bg.gotoAndPlay("close");
				strStatus = "close";
			}
		}
	}

}
