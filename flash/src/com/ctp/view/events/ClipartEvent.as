package com.ctp.view.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ClipartEvent extends Event {
		
		public static const LOAD_IMAGE_COMPLETE: String = "loadImageComplete";
		public static const LOAD_IMAGE_ERROR: String = "loadImageError";
		public static const ADD_IMAGE: String = "addImage";
		public static const ADD_IMAGE_AT_CENTER: String = "addImageAtCenter";
		
		public function ClipartEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event {
			return new ClipartEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ClipartEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}