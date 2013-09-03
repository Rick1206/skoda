package com.ctp.view.components.drawingboard.resizing {
	import com.ctp.model.AppData;
	import com.ctp.model.vo.FontTypeInfo;
	import com.ctp.view.events.ObjectResizingEvent;
	import flash.display.MovieClip;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	
	public class TextResizing extends ObjectResizing {
		
		public static const TEXT_MIN_WIDTH: uint = 100;
		public static const TEXT_MIN_HEIGHT: uint = 25;
		
		public var inputText: TextField;
		
		private var normalFont: SkodaPro = new SkodaPro();
		private var boldFont: SkodaBold = new SkodaBold();
		private var boldItalicFont: SkodaBoldItalic = new SkodaBoldItalic();
		
		//private var chineseFont: JhengHeiIKEA = new JhengHeiIKEA();
		
		private var defaultText: String = "";
		
		public function TextResizing() {
			contentPadding = 12;
			minWidth = TEXT_MIN_WIDTH;
			minHeight = TEXT_MIN_HEIGHT;
			
			inputText = contentMovie.inputText;
			inputText.mouseEnabled = false;
			inputText.multiline = true;
			inputText.wordWrap = true;
			defaultText = inputText.text;
			
			removeChild(deleteButton);
			
			contentMovie.loadingMovie.stop();
			contentMovie.removeChild(contentMovie.loadingMovie);
			
			var i:int;
			for (i = 2; i <= 8; i++) {
				var dotMovie: MovieClip = getChildByName("dot" + i) as MovieClip;
				if (i != 5 && i != 7) {
					dotMovie.scaleX = dotMovie.scaleY = 0;
				}
			}
			if (AppData.parameters.language != "en") {
				rot1.scaleX = rot1.scaleY = 0;
				rot2.scaleX = rot2.scaleY = 0;
				rot3.scaleX = rot3.scaleY = 0;
				rot4.scaleX = rot4.scaleY = 0;
			}
			
			addEventListener(ObjectResizingEvent.CLICK, objectResizingClickHandler);
			closeButton.addEventListener(MouseEvent.CLICK, closeButtonClickHandler);
		}
		
		override public function setTextFormat(data:FontTypeInfo):void {
			var textFormat: TextFormat = new TextFormat();
			textFormat.size = data.fontSize;
			textFormat.underline = data.isUnderline;
			inputText.gridFitType = GridFitType.SUBPIXEL;
			inputText.antiAliasType = AntiAliasType.ADVANCED;
			if (AppData.parameters.language == "en") {
				if (data.isBold) {
					if (data.isItalic) {
						textFormat.font = boldItalicFont.fontName;
						inputText.thickness = 200;
					} else {
						textFormat.font = boldFont.fontName;
						inputText.thickness = 0;
					}
				} else {
					inputText.thickness = 0;
					if (data.isItalic) {
						textFormat.font = boldItalicFont.fontName;
					} else {
						textFormat.font = normalFont.fontName;
					}
				}
			} else {
				if (data.isBold) {
					inputText.thickness = 200;
				} else {
					inputText.thickness = 0;
				}
			}
			inputText.sharpness = 0;
			textFormat.bold = data.isBold;
			textFormat.italic = data.isItalic;
			inputText.setTextFormat(textFormat);
			inputText.defaultTextFormat = textFormat;
		}
		
		override protected function dotMouseDownHandler(e:MouseEvent):void {
			super.dotMouseDownHandler(e);
			inputText.mouseEnabled = false;
		}
		
		private function closeButtonClickHandler(e:MouseEvent):void {
			dispatchEvent(new ObjectResizingEvent(ObjectResizingEvent.DELETE));
		}
		
		private function objectResizingClickHandler(e:ObjectResizingEvent):void {
			inputText.mouseEnabled = borderMovie.visible;
		}
		
		override public function showTool(flag:Boolean = true):void {
			if (isShowingTool == flag) {
				return;
			}
			super.showTool(flag);
			if (inputText) {
				inputText.mouseEnabled = borderMovie.visible;
				if (flag && stage && inputText.text == defaultText) {
					stage.focus = inputText;
					inputText.setSelection(0, defaultText.length);
				}
			}
		}
		
		override public function renderTransformTool():void {
			super.renderTransformTool();
			closeButton.x = dot3.x;
			closeButton.y = dot3.y;
		}
		
		override public function setWidth(value:Number):void {
			inputText.width = value;
			inputText.x = -value / 2;
		}
		
		override public function setHeight(value:Number):void {
			inputText.height = value;
			inputText.y = -value / 2;
		}
		
		override public function getWidth():Number {
			return inputText.width;
		}
		
		override public function getHeight():Number {
			return inputText.height;
		}
		
	}

}