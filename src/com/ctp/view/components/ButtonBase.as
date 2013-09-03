package com.ctp.view.components {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ButtonBase extends MovieClip {
		
		public function ButtonBase() {
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}
		
		private function rollOutHandler(e:MouseEvent):void {
			gotoAndPlay("out");
		}
		
		private function rollOverHandler(e:MouseEvent):void {
			gotoAndPlay("over");
		}
		
	}

}