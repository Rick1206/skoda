package com.ctp.view.components.drawingboard.resizing {
	import com.ctp.model.constant.ObjectType;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ShapeResizing extends ObjectResizing {
		
		private var shapeMovie: MovieClip;
		
		public function ShapeResizing() {
			type = ObjectType.SHAPE;
			
			closeButton.x = 0;
			closeButton.y = 0;
			
			minWidth = minHeight = closeButton.width;
			
			removeChild(deleteButton);
			contentMovie.loadingMovie.stop();
			contentMovie.removeChild(contentMovie.loadingMovie);
			contentMovie.removeChild(contentMovie.inputText);
			
			closeButton.addEventListener(MouseEvent.MOUSE_DOWN, contentMovieMouseDownHandler, false, 0, true);
			closeButton.addEventListener(MouseEvent.CLICK, deleteButtonClickHandler, false, 0, true);
		}
		
		override public function get color(): uint {
			var colorTransform: ColorTransform = shapeMovie.transform.colorTransform;
			return colorTransform.color;
		}
		
		override public function set color(value: uint): void {
			var colorTransform: ColorTransform = shapeMovie.transform.colorTransform;
			colorTransform.color = value;
			shapeMovie.transform.colorTransform = colorTransform;
		}
		
		public function setShape(shape: MovieClip): void {
			shapeMovie = shape;
			shape.mouseChildren = false;
			shape.mouseEnabled = false;
			shape.width = 200;
			shape.scaleY = shape.scaleX;
			shape.x = -shape.width / 2;
			shape.y = -shape.height / 2;
			contentMovie.addChild(shape);
			renderTransformTool();
			isShowingTool = true;
		}
		
		override public function setWidth(value:Number):void {
			shapeMovie.width = value;
			shapeMovie.x = -shapeMovie.width / 2;
		}
		
		override public function setHeight(value:Number):void {
			shapeMovie.height = value;
			shapeMovie.y = -shapeMovie.height / 2;
		}
		
		override public function getWidth():Number {
			return shapeMovie.width;
		}
		
		override public function getHeight():Number {
			return shapeMovie.height;
		}
		
	}

}