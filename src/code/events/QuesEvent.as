package code.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	
	 
	 
	public class QuesEvent extends Event {
		
		public static const UPLOAD: String = "UPLOAD";
		
		private var _talent:String;
		
		private var _inspire:String;
		
		public function QuesEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new QuesEvent(type, bubbles, cancelable);
		} 
		
		
		public function get talent():String 
		{
			return _talent;
		}
		
		public function set talent(value:String):void 
		{
			_talent = value;
		}
		
		
		public function get insprie():String 
		{
			return _inspire;
		}
		
		public function set insprie(value:String):void 
		{
			_inspire = value;
		}
	
	}
	
}