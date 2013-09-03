package com.ctp.view.components {
	
	import com.ctp.view.components.ToggleButtonBase;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ToggleMultiButton extends ToggleButtonBase {
		
		public var selectedButton: ToggleButtonBase;
		public var isShowing: Boolean = false;
		public var stageClicked: Boolean = false;
		
		public function ToggleMultiButton() {
			var arr: Array = [];
			for (var i:int = 0; i < numChildren; i++) {
				arr.push(getChildAt(i));
			}
			arr.sortOn("y", Array.NUMERIC | Array.CASEINSENSITIVE);
			for (var j:int = 0; j < arr.length; j++) {
				arr[j].visible = (j == arr.length - 1);
				arr[j].toggled = !arr[j].visible;
				arr[j].addEventListener(MouseEvent.MOUSE_DOWN, childClickHandler);
			}
			selectedButton = arr[arr.length - 1];
		}
		
		protected function childClickHandler(e:MouseEvent):void {
			e.stopImmediatePropagation();
			var target: ToggleButtonBase = e.currentTarget as ToggleButtonBase;
			stageClicked = false;
			if (target == selectedButton) {
				dispatchEvent(new Event(ToggleButtonBase.TOGGLE_BUTTON_CLICK));
				return;
			}
			var posX: Number = selectedButton.x;
			var posY: Number = selectedButton.y;
			selectedButton.x = target.x;
			selectedButton.y = target.y;
			target.x = posX;
			target.y = posY;
			selectedButton = target;
			dispatchEvent(new Event(ToggleButtonBase.TOGGLE_BUTTON_CLICK));
		}
		
		override protected function init():void {
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		override protected function clickHandler(e:MouseEvent):void {
			e.stopImmediatePropagation();
		}
		
		public function show(flag: Boolean = true):void {
			var i:int;
			var toggleButton: ToggleButtonBase;
			if (flag) {
				for (i = 0; i < numChildren; i++) {
					toggleButton = getChildAt(i) as ToggleButtonBase;
					toggleButton.visible = true;
				}
			} else {
				for (i = 0; i < numChildren; i++) {
					toggleButton = getChildAt(i) as ToggleButtonBase;
					toggleButton.visible = (toggleButton == selectedButton);
				}
			}
			isShowing = flag;
			if (isShowing) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN, stageClickHandler);
			} else {
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageClickHandler);
			}
		}
		
		private function stageClickHandler(e:MouseEvent):void {
			stageClicked = true;
			dispatchEvent(new Event(ToggleButtonBase.TOGGLE_BUTTON_CLICK));
		}
		
		override public function get toggled():Boolean {
			return selectedButton.toggled;
		}
		
		override public function set toggled(value:Boolean):void {
			selectedButton.toggled = value;
			_toggled = value;
			if (value == false) {
				show(false);
			}
		}
	}

}