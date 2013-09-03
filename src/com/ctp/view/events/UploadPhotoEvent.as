package com.ctp.view.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class UploadPhotoEvent extends Event {
		
		public static const COMPLETE: String = "uploadPhotoComplete";
		
		public function UploadPhotoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new UploadPhotoEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("UploadPhotoEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}