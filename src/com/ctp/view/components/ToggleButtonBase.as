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
			init();
		}
		
		protected function init():void {
			//buttonMode = true;
			tabEnabled = false;
			RollTool.setRoll(this);
			gotoAndStop("on");
			
			addEventListener(MouseEvent.CLICK, clickHandler);
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
			} else {
				gotoAndStop("on");
			}
		}
		
	}

}