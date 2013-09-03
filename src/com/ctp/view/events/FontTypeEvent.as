package com.ctp.view.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class FontTypeEvent extends Event {
		
		public static const CHANGE: String = "fontTypeChange";
		public static const ADD_TEXT: String = "addText";
		
		public function FontTypeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new FontTypeEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("FontTypeEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}