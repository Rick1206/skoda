package code
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import code.tool.RollTool;
	import flash.events.MouseEvent;
	
	public class userProfile extends MovieClip
	{
		private var strStatus:String = "close";
		private var _userName:String = "";
		private var _userHead:String = "";
		private var _userQues:Array;
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
		
		public function get userName():String 
		{
			_userName = content.userMc.userName;
			return _userName;
		}
		
		public function set userName(value:String):void 
		{
			_userName = value;
		}
		
		public function get userHead():String 
		{
			_userHead = content.userMc.userHead;
			return _userHead;
		}
		
		public function set userHead(value:String):void 
		{
			_userHead = value;
		}
		
		public function get userQues():Array 
		{
			_userQues = content.userMc.queArr;
			return _userQues;
		}
		
		public function set userQues(value:Array):void 
		{
			
			_userQues = value;
		}
	}

}
