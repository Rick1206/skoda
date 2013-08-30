package com.ctp.view.components.drawingboard.paint {
	import com.ctp.model.constant.BrushType;
	import com.ctp.model.vo.BrushInfo;
	import com.ctp.view.components.ColorSlider;
	import com.ctp.view.components.drawingboard.AirBrushToolUI;
	import com.ctp.view.components.Slider;
	import com.ctp.view.events.BrushEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class AirBrushTool extends AirBrushToolUI {
		
		private var _data: BrushInfo;
		
		public function AirBrushTool() {
			visible = false;
			alpha = 0;
			
			data = new BrushInfo();
			data.type = BrushType.AIR_BRUSH;
			
			colorSliderMovie.addEventListener(ColorSlider.CHANGE, colorSliderChangeHandler);
			sizeSliderMovie.addEventListener(Slider.CHANGE, sizeSliderChangeHandler);
			blurSliderMovie.addEventListener(Slider.CHANGE, blurSliderMovieChangeHandler);
		}
		
		private function colorSliderChangeHandler(e:Event):void {
			_data.color = colorSliderMovie.color;
			dispatchEvent(new BrushEvent(BrushEvent.CHANGE));
		}
		
		private function sizeSliderChangeHandler(e:Event):void {
			_data.percent = sizeSliderMovie.percent;
			dispatchEvent(new BrushEvent(BrushEvent.CHANGE));
		}
		
		private function blurSliderMovieChangeHandler(e:Event):void {
			_data.blur = 1 - blurSliderMovie.percent;
			dispatchEvent(new BrushEvent(BrushEvent.CHANGE));
		}
		
		public function get data():BrushInfo {
			return _data;
		}
		
		public function set data(value:BrushInfo):void {
			_data = value;
			colorSliderMovie.toggled = false;
			sizeSliderMovie.percent = value.percent;
			blurSliderMovie.percent = value.blur;
		}
		
	}

}