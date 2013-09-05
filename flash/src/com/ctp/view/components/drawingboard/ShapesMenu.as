package com.ctp.view.components.drawingboard {
	import com.ctp.model.vo.BrushInfo;
	import com.ctp.view.components.ColorSlider;
	import com.ctp.view.events.ShapeEvent;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ShapesMenu extends ShapesMenuUI {
		
		private var isDragging: Boolean = false;
		private var classes: Array = [Shape1, Shape2, Shape3, Shape4, Shape5, Shape6, Shape7, Shape8, Shape9, Shape10, Shape11, Shape12];
		private var dragItem: MovieClip = new MovieClip();
		private var currentTarget: MovieClip = new MovieClip();
		
		public function ShapesMenu() {
			visible = false;
			alpha = 0;
			
			colorSliderMovie.setDocked();
			colorSliderMovie.addEventListener(ColorSlider.CHANGE, colorSliderChangeHandler);
			
			for (var i:int = 0; i < contentMovie.numChildren; i++) {
				var item: MovieClip = contentMovie.getChildAt(i) as MovieClip;
				item.buttonMode = true;
				item.tabEnabled = false;
				item.doubleClickEnabled = true;
				item.addEventListener(MouseEvent.MOUSE_DOWN, itemMouseDownHandler);
				item.addEventListener(MouseEvent.DOUBLE_CLICK, itemDoubleClickHandler);
			}
		}
		
		private function colorSliderChangeHandler(e:Event):void {
			dispatchEvent(new ShapeEvent(ShapeEvent.CHANGE_COLOR));
		}
		
		public function getShape(): MovieClip {
			var shapeClass: Class = classes[uint(currentTarget.name.split("shape")[1]) - 1] as Class;
			var colorTransform: ColorTransform = new ColorTransform();
			colorTransform.color = colorSliderMovie.color;
			var shapeMovie: MovieClip = new shapeClass();
			shapeMovie.transform.colorTransform = colorTransform;
			return shapeMovie;
		}
		
		private function itemDoubleClickHandler(e:MouseEvent):void {
			dispatchEvent(new ShapeEvent(ShapeEvent.ADD_SHAPE_AT_CENTER));
		}
		
		private function itemMouseDownHandler(e:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			
			currentTarget = e.currentTarget as MovieClip;
			var bmd: BitmapData = new BitmapData(currentTarget.width, currentTarget.height, true, 0);
			bmd.draw(currentTarget, null, null, null, null, true);
			dragItem.graphics.clear();
			dragItem.graphics.beginBitmapFill(bmd, null, false, true);
			dragItem.graphics.drawRect(0, 0, currentTarget.width, currentTarget.height);
			dragItem.graphics.endFill();
			
			dragItem.x = stage.mouseX;
			dragItem.y = stage.mouseY;
		}
		
		private function mouseUpHandler(e:MouseEvent):void {
			mouseLeaveHandler(null);
			if (isDragging) {
				isDragging = false;
				dispatchEvent(new ShapeEvent(ShapeEvent.ADD_SHAPE));
			}
		}
		
		private function mouseLeaveHandler(e:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			
			if (this.contains(dragItem)) {
				dragItem.stopDrag();
				removeChild(dragItem);
			}
			
			if (e != null) {
				isDragging = false;
			}
		}
		
		private function mouseMoveHandler(e:MouseEvent):void {
			var distanceX: int = Math.abs(stage.mouseX - dragItem.x);
			var distanceY: int = Math.abs(stage.mouseY - dragItem.y);
			if (distanceX >= 3 && distanceY >= 3) {
				isDragging = true;
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				dragItem.x = stage.mouseX - (dragItem.width / 2);
				dragItem.y = stage.mouseY - (dragItem.height / 2);
				addChild(dragItem);
				dragItem.startDrag();
			}
		}
		
	}

}