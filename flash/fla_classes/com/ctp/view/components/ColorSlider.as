package com.ctp.view.components {
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ColorSlider extends MovieClip {
		
		public static const CHANGE: String = "colorSliderChange";
		
		public var frameColorMovie: MovieClip;
		public var fillColorMovie: MovieClip;
		public var colorMovie: MovieClip;
		public var handleMovie: MovieClip;
		public var whiteMovie: MovieClip;
		public var blackMovie: MovieClip;
		public var contentMovie: MovieClip;
		
		public var color: uint = 0xFF000000;
		private var colorBmpData: BitmapData;
		private var bounds: Rectangle;
		private var colorTransform:ColorTransform;
		
		public function ColorSlider() {
			colorTransform = new ColorTransform();
			colorMovie = contentMovie.colorMovie;
			handleMovie = contentMovie.handleMovie;
			whiteMovie = contentMovie.whiteMovie;
			blackMovie = contentMovie.blackMovie;
			
			colorBmpData = new BitmapData(colorMovie.width, colorMovie.height, false);
			colorBmpData.draw(colorMovie);
			
			bounds = new Rectangle(handleMovie.x, 45, 0, 147);
			handleMovie.buttonMode = true;
			handleMovie.tabEnabled = false;
			handleMovie.addEventListener(MouseEvent.MOUSE_DOWN, handleMovieMouseDownHandler);
			
			colorMovie.buttonMode = true;
			colorMovie.tabEnabled = false;
			colorMovie.addEventListener(MouseEvent.MOUSE_DOWN, colorMovieMouseDownHandler);
			
			whiteMovie.buttonMode = true;
			whiteMovie.tabEnabled = false;
			whiteMovie.addEventListener(MouseEvent.CLICK, colorMovieClickHandler);
			
			blackMovie.buttonMode = true;
			blackMovie.tabEnabled = false;
			blackMovie.addEventListener(MouseEvent.CLICK, colorMovieClickHandler);
			
			frameColorMovie.addEventListener(MouseEvent.CLICK, frameColorMovieClickHandler);
			addEventListener(ColorSlider.CHANGE, colorSliderChangeHandler);
		}
		
		public function setDocked():void {
			frameColorMovie.removeEventListener(MouseEvent.CLICK, frameColorMovieClickHandler);
			contentMovie.visible = true;
			contentMovie.alpha = 1;
			contentMovie.scaleY = 1;
		}
		
		private function colorSliderChangeHandler(e:Event):void {
			colorTransform.color = color;
			fillColorMovie.transform.colorTransform = colorTransform;
		}
		
		private function frameColorMovieClickHandler(e:MouseEvent):void {
			frameColorMovie.toggled = !frameColorMovie.toggled;
			if (frameColorMovie.toggled) {
				TweenLite.to(contentMovie, 0.2, { autoAlpha: 1, scaleY: 1 } );
			} else {
				TweenLite.to(contentMovie, 0.2, { autoAlpha: 0, height: 1 } );
			}
		}
		
		public function get toggled(): Boolean {
			return frameColorMovie.toggled;
		}
		
		public function set toggled(value: Boolean):void {
			frameColorMovie.toggled = value;
			if (!value) {
				contentMovie.visible = false;
				contentMovie.alpha = 0;
				contentMovie.height = 1;
			}
		}
		
		private function colorMovieMouseDownHandler(e:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageColorMouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageColorMouseUpHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, stageColorMouseUpHandler);
			stageColorMouseMoveHandler(null);
		}
		
		private function stageColorMouseUpHandler(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageColorMouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageColorMouseUpHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, stageColorMouseUpHandler);
		}
		
		private function stageColorMouseMoveHandler(e:MouseEvent):void {
			handleMovie.y = bounds.y + colorMovie.mouseY - 2;
			if (handleMovie.y < bounds.y) {
				handleMovie.y = bounds.y;
			} else if (handleMovie.y > bounds.y + bounds.height) {
				handleMovie.y = bounds.y + bounds.height;
			}
			enterFrameHandler(null);
		}
		
		private function colorMovieClickHandler(e:MouseEvent):void {
			switch (e.currentTarget) {
				case whiteMovie:
					color = 0xFFFFFFFF;
					dispatchEvent(new Event(CHANGE));
					break;
				case blackMovie:
					color = 0xFF000000;
					dispatchEvent(new Event(CHANGE));
					break;
			}
		}
		
		private function handleMovieMouseDownHandler(e:MouseEvent):void {
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseLeaveHandler);
			
			handleMovie.startDrag(false, bounds);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void {
			color = colorBmpData.getPixel32(int(colorBmpData.width / 2), int(handleMovie.y - bounds.y) + 2);
			dispatchEvent(new Event(CHANGE));
		}
		
		private function mouseLeaveHandler(e:Event):void {
			stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseLeaveHandler);
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			handleMovie.stopDrag();
		}
		
	}

}