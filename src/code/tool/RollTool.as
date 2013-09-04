package code.tool {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class RollTool extends MovieClip {
	
		public function RollTool() {
			
		}
		public static function setRoll(mc:DisplayObject):void {
			mc.addEventListener(MouseEvent.ROLL_OVER, onRollHandle);
			mc.addEventListener(MouseEvent.ROLL_OUT, onRollHandle);
		}
		public static function onRollHandle(e:MouseEvent):void {
			switch(e.type) {
				case "rollOut":
					Mouse.cursor = MouseCursor.ARROW;
					break;
				case "rollOver":
					Mouse.cursor = MouseCursor.BUTTON;
					break;
			}
		}
		
	}
	
}
