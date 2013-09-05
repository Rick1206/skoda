package com.ctp.view.components.drawingboard {
	import com.ctp.view.events.ManagaEvent;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ConfirmBox extends ConfirmUI {
		
		public function ConfirmBox() {
			visible = false;
			alpha = 0;
			noButton.addEventListener(MouseEvent.CLICK, noButtonClickHandler);
			yesButton.addEventListener(MouseEvent.CLICK, noButtonClickHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
		}
		
		private function stageClickHandler(e:MouseEvent):void {
			if (alpha == 1 && this.hitTestPoint(stage.mouseX, stage.mouseY) == false) {
				noButtonClickHandler(null);
			}
		}
		
		private function noButtonClickHandler(e:MouseEvent):void {
			TweenLite.to(this, 0.2, { autoAlpha: 0 } );
		}
		
		public function show(message: String): void {
			messageMovie.gotoAndPlay(message);
			if (message == ManagaEvent.CLEAR_ALL) {
				yesButton.y = noButton.y = 37;
			} else {
				yesButton.y = noButton.y = 27;
			}
			TweenLite.to(this, 0.2, { autoAlpha: 1 } );
		}
		
	}

}