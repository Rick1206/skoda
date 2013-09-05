package com.ctp.view.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class BrushEvent extends Event {
		
		public static const CHANGE: String = "brushChange";
		public static const ENABLE: String = "brushEnable";
		public static const DISABLE: String = "brushDisable";
		
		public function BrushEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new BrushEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("BrushEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}