package com.ctp.view.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class UploadPhotoEvent extends Event {
		
		public static const COMPLETE: String = "uploadPhotoComplete";
		
		private var _ptype:String;
		
		public function UploadPhotoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new UploadPhotoEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("UploadPhotoEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get ptype():String 
		{
			return _ptype;
		}
		
		public function set ptype(value:String):void 
		{
			_ptype = value;
		}
		
	}
	
}