package com.ctp.view.components.drawingboard.paint {
	import com.ctp.model.constant.BrushType;
	import com.ctp.model.vo.BrushInfo;
	import com.ctp.view.components.ColorSlider;
	import com.ctp.view.components.drawingboard.PaintBucketToolUI;
	import com.ctp.view.events.BrushEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class PaintBucketTool extends PaintBucketToolUI {
		
		private var _data: BrushInfo;
		
		public function PaintBucketTool() {
			visible = false;
			alpha = 0;
			
			data = new BrushInfo();
			data.type = BrushType.PAINT;
			
			colorSliderMovie.setDocked();
			colorSliderMovie.addEventListener(ColorSlider.CHANGE, colorSliderChangeHandler);
		}
		
		private function colorSliderChangeHandler(e:Event):void {
			_data.color = colorSliderMovie.color;
			dispatchEvent(new BrushEvent(BrushEvent.CHANGE));
		}
		
		public function get data():BrushInfo {
			return _data;
		}
		
		public function set data(value:BrushInfo):void {
			_data = value;
			colorSliderMovie.toggled = false;
		}
		
	}

}