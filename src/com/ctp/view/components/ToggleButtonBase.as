package com.ctp.view.components {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import code.tool.RollTool;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ToggleButtonBase extends MovieClip {
		
		public static const TOGGLE_BUTTON_CLICK: String = "TOGGLE_BUTTON_CLICK";
		
		protected var _toggled: Boolean = false;
		
		public function ToggleButtonBase() {
			if (stage) {
				
			}else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		protected function init(e:Event=null):void {
			tabEnabled = false;
			RollTool.setRoll(this);
			gotoAndStop("on");
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(MouseEvent.ROLL_OUT, onRollStatusHandler);
			addEventListener(MouseEvent.ROLL_OVER, onRollStatusHandler);
		}
		
		private function onRollStatusHandler(e:MouseEvent):void 
		{
			switch(e.type) {
				case "rollOut":
					gotoAndStop("on");
					break;
				case "rollOver":
					gotoAndStop("off");
					break;
			}
		}
		
		protected function clickHandler(e:MouseEvent):void {
			dispatchEvent(new Event(TOGGLE_BUTTON_CLICK));
		}
		
		public function get toggled():Boolean {
			return _toggled;
		}
		
		public function set toggled(value:Boolean):void {
			_toggled = value;
			if (toggled) {
				gotoAndStop("off");
				removeEventListener(MouseEvent.ROLL_OUT, onRollStatusHandler);
			} else {
				gotoAndStop("on");
				addEventListener(MouseEvent.ROLL_OUT, onRollStatusHandler);
			}
		}
		
	}

}