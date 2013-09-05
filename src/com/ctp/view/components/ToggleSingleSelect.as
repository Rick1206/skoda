package com.ctp.view.components {
	
	import com.ctp.view.components.ToggleMultiButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ToggleSingleSelect extends ToggleMultiButton {
		
		public var defaultButton: ToggleButtonBase;
		
		public function ToggleSingleSelect() {
			super("x");
		}
		
		override protected function childClickHandler(e:MouseEvent):void {
			e.stopImmediatePropagation();
			stageClicked = false;
			defaultButton = e.currentTarget as ToggleButtonBase;
			if (defaultButton == selectedButton) {
				show(!selectedButton.toggled);
			} else {
				show(!isShowing);
			}
			dispatchEvent(new Event(ToggleButtonBase.TOGGLE_BUTTON_CLICK));
		}
		
		override public function show(param0:Boolean = true):void {
			super.show(param0);
			selectedButton.toggled = isShowing;
		}
		
		
		override public function get toggled():Boolean {
			return super.toggled;
		}
		
		override public function set toggled(value:Boolean):void {
			super.toggled = value;
			if (value) {
				show();
			}
		}
	}

}