package code.view
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class btnsubmission extends MovieClip
	{
		
		public function btnsubmission()
		{
			if (stage) {
				init();
			}else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
			
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(MouseEvent.ROLL_OUT, onRollHandler);
			addEventListener(MouseEvent.ROLL_OVER, onRollHandler);
		}
		
		private function onRollHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case "rollOut": 
					this.gotoAndStop(1);
					break;
				case "rollOver": 
					this.gotoAndStop(2);
					break;
			}
		}
	}
}
