package com.ctp.view.components.drawingboard.paint {
	import com.ctp.model.constant.BrushType;
	import com.ctp.model.vo.BrushInfo;
	import com.ctp.view.components.drawingboard.resizing.ObjectResizing;
	import com.ctp.view.components.drawingboard.ToolBar;
	import com.hangunsworld.util.BMPFunctions;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class BrushBoard extends Sprite {
		
		private const MAX_THICKNESS: uint = 10;
		private const MAX_BLUR: uint = 8;
		
		private var hiddenMovie: Sprite = new Sprite();		
		private var graphicMovie: Sprite = new Sprite();		
		private var isEnabled: Boolean = false;
		private var startX: Number;
		private var startY: Number;
		private var brush: BrushInfo;
		private var lastX: Number;
		private var lastY: Number;
		private var blurFilter: BlurFilter = new BlurFilter();
		private var cachedGraphic: BitmapData;
		
		public var toolBarMovie: ToolBar;
		
		public function BrushBoard() {
			mouseEnabled = false;
			mouseChildren = false;
			hiddenMovie.x = 1000;
			addChild(hiddenMovie);
			addChild(graphicMovie);
		}
		
		public function get painEnabled(): Boolean {
			if (brush) {
				return brush.type == BrushType.PAINT && isEnabled;
			}
			return false;
		}
		
		public function get isEmpty(): Boolean {
			var bmd: BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0xFFFFFF);
			bmd.draw(graphicMovie);
			for (var i:int = 0; i < bmd.width; i++) {
				for (var j:int = 0; j < bmd.height; j++) {
					if (bmd.getPixel(i,j) != 0xFFFFFF) {
						return false;
					}
				}
			}
			return true;
		}
		
		public function setEnabled(value: Boolean, info: BrushInfo = null): void {
			if (info && value) {
				brush = info;
				blurFilter.blurX = info.blur * MAX_BLUR;
				blurFilter.blurY = info.blur * MAX_BLUR;
				blurFilter.quality = BitmapFilterQuality.MEDIUM;
				graphicMovie.graphics.lineStyle(info.percent * MAX_THICKNESS, info.color, 1, true, LineScaleMode.NONE, CapsStyle.ROUND);
			}
			if (isEnabled != value) {
				if (value) {
					stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
				} else {
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
				}
			}
			isEnabled = value;
		}

		private function stageMouseDownHandler(e:MouseEvent):void {
			if (brush.type == BrushType.PAINT) {
				if (toolBarMovie.buttonGroupMovie.hitTestPoint(mouseX, mouseY, true)) {
					return;
				}
				var bmd: BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x000000);
				bmd.draw(graphicMovie);
				//bmd.floodFill(mouseX, mouseY, brush.color);
				var c2:uint = uint("0x" + brush.color.toString(16).toUpperCase());
				bmd = BMPFunctions.floodFill(bmd, mouseX, mouseY, c2, 100, true);
				graphicMovie.graphics.clear();
				graphicMovie.graphics.beginBitmapFill(bmd, null, false, true);
				graphicMovie.graphics.drawRect(0, 0, bmd.width, bmd.height);
				graphicMovie.graphics.endFill();
				return;
			}
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, stageMouseUpHandler);
			
			startX = mouseX;
			startY = mouseY;
			lastX = mouseX;
			lastY = mouseY;
			
			if (brush.type == BrushType.BRUSH) {
				graphicMovie.graphics.moveTo(mouseX, mouseY);
			} else {
				if (brush.type == BrushType.AIR_BRUSH) {
					cachedGraphic = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0);
					cachedGraphic.draw(graphicMovie);
				}
				hiddenMovie.graphics.clear();
				hiddenMovie.graphics.lineStyle(brush.percent * MAX_THICKNESS, brush.color, 1, true, LineScaleMode.NONE, CapsStyle.ROUND);
				hiddenMovie.graphics.moveTo(mouseX, mouseY);
			}
		}
		
		private function enterFrameHandler(e:Event):void {
			if (lastX == mouseX && lastY == mouseY) {
				return;
			}
			lastX = mouseX;
			lastY = mouseY;
			if (brush.type == BrushType.BRUSH) {
				graphicMovie.graphics.lineTo(mouseX, mouseY);
			} else {
				hiddenMovie.graphics.lineTo(mouseX, mouseY);
				draw();
			}
		}
		
		private function stageMouseUpHandler(e:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, stageMouseUpHandler);
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			if (mouseX == startX && mouseY == startY && isEnabled) {
				if (brush.type == BrushType.BRUSH) {
					graphicMovie.graphics.lineTo(mouseX + 1, mouseY + 1);
				} else {
					hiddenMovie.graphics.lineTo(mouseX + 1, mouseY + 1);
					draw();
				}
			}
		}
		
		private function stageMouseMoveHandler(e:MouseEvent):void {
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
		}
		
		private function draw(): void {
			var bmd: BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0);
			//trace(stage.stageWidth);
			bmd.draw(graphicMovie);
			graphicMovie.graphics.clear();
			if (brush.type == BrushType.ERASER) {
				bmd.draw(hiddenMovie, null, null, BlendMode.ERASE);
			} else if (brush.type == BrushType.AIR_BRUSH) {
				var hidden: BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0);
				hidden.draw(hiddenMovie);
				bmd.applyFilter(hidden, new Rectangle(0, 0, hidden.width, hidden.height), new Point(), blurFilter);
				
				graphicMovie.graphics.beginBitmapFill(cachedGraphic, null, false, true);
				graphicMovie.graphics.drawRect(0, 0, cachedGraphic.width, cachedGraphic.height);
				graphicMovie.graphics.endFill();
			}
			graphicMovie.graphics.beginBitmapFill(bmd, null, false, true);
			graphicMovie.graphics.drawRect(0, 0, bmd.width, bmd.height);
			graphicMovie.graphics.endFill();
		}
		
		public function clear():void {
			graphicMovie.graphics.clear();
			hiddenMovie.graphics.clear();
		}
		
	}

}