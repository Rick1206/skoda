package com.ctp.view.components.drawingboard {
	
	import com.ctp.view.components.drawingboard.resizing.ObjectResizing;
	import com.ctp.view.components.drawingboard.resizing.TextResizing;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import com.ctp.view.components.ToggleButtonBase;
	import com.ctp.view.components.ToggleGroupBase;
	import com.ctp.view.events.FontTypeEvent;
	import com.ctp.model.constant.FontSize;
	import com.ctp.model.vo.FontTypeInfo;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class TypeTool extends TypeToolUI {
		
		private var _data: FontTypeInfo;
		private var isEnabled: Boolean = false;
		
		public var selectedBounds: Rectangle = new Rectangle();
		
		public function TypeTool() {
			
			visible = false;
			alpha = 0;
			
			selectedBounds.width = 270;
			
			selectedBounds.height = 138;
			
			selectedBounds.x = (ObjectResizing.MAX_WIDTH / 2) - (selectedBounds.width/2);
			selectedBounds.y = (ObjectResizing.MAX_HEIGHT / 2) - (selectedBounds.height/2);
			
			//var bmd:BitmapData = new BitmapData(270, 138, false, 0xFFCC00);
			//var bm:Bitmap = new Bitmap(bmd);
			//bm.x = selectedBounds.x;
			//bm.y = selectedBounds.y;
			//addChild(bm);
			
			fontSizeMovie.addEventListener(MouseEvent.CLICK, fontStyleMovieClickHandler);
			
			boldMovie.addEventListener(MouseEvent.CLICK, fontStyleMovieClickHandler);
			
			italicMovie.addEventListener(MouseEvent.CLICK, fontStyleMovieClickHandler);
			
			underlineMovie.addEventListener(MouseEvent.CLICK, fontStyleMovieClickHandler);
			
		}
		
		public function setEnabled(value: Boolean): void {
			if (isEnabled == value) {
				return;
			}
			isEnabled = value;
		}
		
		private function fontStyleMovieClickHandler(e:MouseEvent):void {
			e.stopImmediatePropagation();
			var currentTarget: ToggleButtonBase = e.currentTarget as ToggleButtonBase;
			currentTarget.toggled = !currentTarget.toggled;
			switch (currentTarget) {
				case boldMovie:
					_data.isBold = currentTarget.toggled;
					break;
				case italicMovie:
					_data.isItalic = currentTarget.toggled;
					break;
				case underlineMovie:
					_data.isUnderline = currentTarget.toggled;
					break;
				case fontSizeMovie:
					if (currentTarget.toggled) {
						_data.fontSize = FontSize.LARGE;
					}else {
						_data.fontSize = FontSize.MED;
					}
					break;	
					
			}
			dispatchEvent(new FontTypeEvent(FontTypeEvent.CHANGE));
		}
		
		public function get data():FontTypeInfo {
			return _data;
		}
		
		public function set data(value:FontTypeInfo):void {
			_data = value;
			
			if (_data.fontSize == FontSize.LARGE) {
				fontSizeMovie.toggled = true;
			}else {
				fontSizeMovie.toggled = false;
			}
			boldMovie.toggled = _data.isBold;
			italicMovie.toggled = _data.isItalic;
			underlineMovie.toggled = _data.isUnderline;
		}
		
		private function fontSizeMovieClickHandler(e:MouseEvent):void {
			e.stopImmediatePropagation();
			fontSizeMovie.toggled = !fontSizeMovie.toggled;
			if (fontSizeMovie.toggled) {
				_data.fontSize = FontSize.LARGE;
			} else {
				_data.fontSize = FontSize.MED;
			}
			dispatchEvent(new FontTypeEvent(FontTypeEvent.CHANGE));
		}
		
	}

}