package code
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import code.tool.RollTool;
	import flash.events.MouseEvent;
	
	public class userProfile extends MovieClip
	{
		private var strStatus:String = "close";
		
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
			
			RollTool.setRoll(content.boardMc);
			
			content.boardMc.addEventListener(MouseEvent.CLICK, onClickHandler);
			
			
			
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			if (strStatus == "close")
			{
				this.content.gotoAndPlay("expand");
				
				strStatus = "expand";
			}
		}
		
		public function open()
		{
			this.content.gotoAndPlay("expand");
			strStatus = "expand";
		}
		
		public function close()
		{
			if (strStatus == "expand")
			{
				this.content.gotoAndPlay("close");
				strStatus = "close";
			}
		}
	}

}
