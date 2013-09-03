package com.ctp.view.components {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ToggleGroupBase extends MovieClip {
		
		public var toggledButton: ToggleButtonBase = null;
		
		public function ToggleGroupBase() {
			for (var i:int = 0; i < numChildren; i++) {
				getChildAt(i).addEventListener(ToggleButtonBase.TOGGLE_BUTTON_CLICK, childClickHandler);
			}
		}
		
		public function reset(): void {
			if (toggledButton) {
				toggledButton.toggled = false;
				toggledButton = null;
			}
		}
		
		public function setToggledButton(target: ToggleButtonBase): void {
			if (target != toggledButton) {
				reset();
				toggledButton = target;
				toggledButton.toggled = true;
			}
		}
		
		private function childClickHandler(e:Event):void {
			setToggledButton(e.currentTarget as ToggleButtonBase);
			dispatchEvent(e);
		}
		
	}

}