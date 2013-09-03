package com.ctp.view.components.drawingboard {
	import com.ctp.view.components.drawingboard.resizing.ObjectResizing;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class PopupWindow extends PopupUI {
		
		private const PADDING: int  = 10;
		private var isShowing: Boolean = false;
		private var parentMovie: DisplayObjectContainer;
		
		public function PopupWindow() {
			contentText.autoSize = TextFieldAutoSize.LEFT;
			closeButton.addEventListener(MouseEvent.CLICK, closeButtonClickHandler);
		}
		
		private function closeButtonClickHandler(e:MouseEvent):void {
			if (isShowing == false) {
				return;
			}
			isShowing = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageClickHandler);
			if (stage && parentMovie && parentMovie.contains(this)) {
				parentMovie.removeChild(this);
			}
		}
		
		public function show(content: String, parentMovie: DisplayObjectContainer):void {
			if (isShowing) {
				return;
			}
			this.parentMovie = parentMovie;
			isShowing = true;
			contentText.htmlText = content;
			var contentHeight: int = contentText.textHeight + PADDING + closeButton.height;
			contentText.y = -contentHeight / 2;
			closeButton.y = contentText.y + contentText.textHeight + PADDING;
			this.x = ObjectResizing.MAX_WIDTH / 2;
			this.y = ObjectResizing.MAX_HEIGHT / 2;
			parentMovie.addChild(this);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageClickHandler);
		}
		
		private function stageClickHandler(e:MouseEvent):void {
			if (e.target != bgMovie && e.target != contentText && e.target != closeButton) {
				closeButtonClickHandler(null);
			}
		}
		
	}

}