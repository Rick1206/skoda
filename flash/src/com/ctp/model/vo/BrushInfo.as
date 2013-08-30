package com.ctp.model.vo {
	import com.ctp.model.constant.BrushType;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class BrushInfo {
		
		public var percent: Number = 0.5;
		public var blur: Number = 0.5;
		public var color: uint = 0xFF000000;
		public var type: String = BrushType.BRUSH;
		
		public function BrushInfo() {
			
		}
		
	}

}