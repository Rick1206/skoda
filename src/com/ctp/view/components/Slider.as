package com.ctp.view.components {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class Slider extends MovieClip {
		
		public static const CHANGE: String = "sliderChange";
		
		public var handleMovie: MovieClip;
		private var _percent: Number;
		private var sliderBounds:Rectangle;
		
		public function Slider() {
			sliderBounds = new Rectangle(-82, handleMovie.y, 160);
			
			handleMovie.buttonMode = true;
			handleMovie.tabEnabled = false;
			handleMovie.alpha = 0;
			
			handleMovie.addEventListener(MouseEvent.MOUSE_DOWN, handleMovieMouseDownHandler);
		}

		private function handleMovieMouseDownHandler(e:MouseEvent):void {
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseLeaveHandler);
			
			handleMovie.startDrag(false, sliderBounds);
			addEventListener(Event.ENTER_FRAME, updateSliderHandler);
		}
		
		private function updateSliderHandler(e:Event):void {
			sliderMovie.x = handleMovie.x;
		}
		
		private function mouseLeaveHandler(e:Event):void {
			stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseLeaveHandler);
			removeEventListener(Event.ENTER_FRAME, updateSliderHandler);
			
			handleMovie.stopDrag();
			_percent = (handleMovie.x - sliderBounds.x) / sliderBounds.width;
			dispatchEvent(new Event(CHANGE));
		}
		
		public function get percent():Number {
			//trace(_percent);
			return _percent;
			
		}
		
		public function set percent(value:Number):void {
			_percent = value;
			handleMovie.x = sliderBounds.x + (sliderBounds.width * percent);
			sliderMovie.x = handleMovie.x;
		}
		
	}

}