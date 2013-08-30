package com.ctp.view.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ShapeEvent extends Event {
		
		public static const ADD_SHAPE: String = "addShape";
		public static const CHANGE_COLOR: String = "changeColorShape";
		public static const ADD_SHAPE_AT_CENTER: String = "addShapeAtCenter";
		
		public function ShapeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event {
			return new ShapeEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ShapeEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}