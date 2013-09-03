package com.ctp.view.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ObjectResizingEvent extends Event {
		
		public static const CLICK: String = "objectResizingClick";
		public static const DELETE: String = "objectResizingDelete";
		
		public function ObjectResizingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new ObjectResizingEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ObjectResizingEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}