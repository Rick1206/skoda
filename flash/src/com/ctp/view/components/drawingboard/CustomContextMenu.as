package com.ctp.view.components.drawingboard {
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class CustomContextMenu extends ContextMenuUI {
		
		public function CustomContextMenu() {
			visible = false;
			alpha = 0;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, rightClickHandler);
			//stage.addEventListener(MouseEvent.RIGHT_CLICK, rightClickHandler);
		}
		
		private function rightClickHandler(e:MouseEvent):void {
			hide();
		}
		
		public function show(): void {
			x = stage.mouseX;
			y = stage.mouseY;
			TweenLite.to(this, 0.2, { autoAlpha: 1, overwrite: true } );
		}
		
		public function hide(): void {
			if (visible) {
				TweenLite.to(this, 0.2, { autoAlpha: 0, overwrite: true } );
			}
		}
		
	}

}