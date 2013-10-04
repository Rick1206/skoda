package com.ctp.view.components.drawingboard.paint {
	import com.ctp.model.constant.BrushType;
	import com.ctp.model.vo.BrushInfo;
	import com.ctp.view.components.ColorSlider;
	import com.ctp.view.components.drawingboard.EraserToolUI;
	import com.ctp.view.components.Slider;
	import com.ctp.view.events.BrushEvent;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class EraserTool extends EraserToolUI {
		
		private var _data: BrushInfo;
		
		public function EraserTool() {
			visible = false;
			alpha = 0;
			
			data = new BrushInfo();
			data.type = BrushType.ERASER;
			data.percent = 0.5;
			
			sizeSliderMovie.addEventListener(Slider.CHANGE, sizeSliderChangeHandler);
		}
		
		private function sizeSliderChangeHandler(e:Event):void {
			_data.percent = sizeSliderMovie.percent * 1.8;
		}
		
		private function colorSliderChangeHandler(e:Event):void {
		
		}
		
		private function eraserMovieClickHandler(e:MouseEvent):void {
		
		}
		
		public function get data():BrushInfo {
			return _data;
		}
		
		public function set data(value:BrushInfo):void {
			_data = value;
			sizeSliderMovie.percent = value.percent;
		}
		
	}

}