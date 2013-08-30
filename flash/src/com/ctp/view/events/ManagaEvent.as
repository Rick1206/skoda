package com.ctp.view.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ManagaEvent extends Event {
		
		public static const SEND_TO_BACK	: String = "sendToBack";
		public static const BRING_TO_FRONT	: String = "bringToFront";
		public static const CLEAR_ALL		: String = "clearAll";
		
		public function ManagaEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new ManagaEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ManagaEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}