package com.ctp.view.components.drawingboard.paint
{
	import com.ctp.model.constant.BrushType;
	import com.ctp.model.vo.BrushInfo;
	import com.ctp.view.components.drawingboard.resizing.ObjectResizing;
	import com.ctp.view.components.drawingboard.ToolBar;
	import com.hangunsworld.util.BMPFunctions;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.PixelSnapping;

	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class BrushBoard extends Sprite
	{
		
		private const MAX_THICKNESS:uint = 10;
		private const MAX_BLUR:uint = 8;
		
		private var hiddenMovie:Sprite = new Sprite();
		private var graphicMovie:Sprite = new Sprite();
		
		private var isEnabled:Boolean = false;
		private var startX:Number;
		private var startY:Number;
		private var brush:BrushInfo;
		private var lastX:Number;
		private var lastY:Number;
		private var blurFilter:BlurFilter = new BlurFilter();
		private var cachedGraphic:BitmapData;
		//testing
		public var toolBarMovie:ToolBar;
		
		private var numBorderW:Number = 624;
		private var numBorderH:Number = 624;
		
		private var bmd:BitmapData;
		private var bmp:Bitmap;
		
		private var sp:Sprite;
		
		private var myMatrix:Matrix = new Matrix();
		
		public function BrushBoard()
		{
			
			
			bmd = new BitmapData(numBorderW, numBorderH, true, 0);
			bmp = new Bitmap(bmd,PixelSnapping.AUTO,true);

			addChild(bmp);
			
			if (stage) {
					init()
			}else {
				addEventListener(Event.ADDED_TO_STAGE, init);	
			}
			
			var bgbmd:BitmapData = new BitmapData(numBorderW, numBorderH, true, 0);
			var mybmp:Bitmap = new Bitmap(bgbmd);
			
			graphicMovie.addChild(mybmp);
			
			addChild(graphicMovie);
		
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(Event.RESIZE, onResizeHandler);
		}
		
		private function onResizeHandler(e:Event):void 
		{
			graphicMovie.x = bmp.x;
			graphicMovie.y = bmp.y;
		}
		
		public function get painEnabled():Boolean
		{
			if (brush)
			{
				return brush.type == BrushType.PAINT && isEnabled;
			}
			return false;
		}
		
		public function get isEmpty():Boolean
		{
			var mybmd = new BitmapData(numBorderW, numBorderH, false, 0xFFFFFF);
			mybmd.draw(graphicMovie);
			
			
			//trace("is empty");
			for (var i:int = 0; i < mybmd.width; i++)
			{
				for (var j:int = 0; j < mybmd.height; j++)
				{
					if (mybmd.getPixel(i, j) != 0xFFFFFF)
					{
						return false;
					}
				}
			}
			trace("is empty : true");
			return true;
		}
		
		public function setEnabled(value:Boolean, info:BrushInfo = null):void
		{
			if (info && value)
			{
				brush = info;
				blurFilter.blurX = info.blur * MAX_BLUR;
				blurFilter.blurY = info.blur * MAX_BLUR;
				blurFilter.quality = BitmapFilterQuality.MEDIUM;
				
			}
			
			if (isEnabled != value)
			{
				if (value)
				{
					this.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
					
				}
				else
				{
					this.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
				}
			}
			
			isEnabled = value;
		}
		
		private function stageMouseDownHandler(e:MouseEvent):void
		{
			
			graphicMovie.graphics.clear();
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			
			this.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, stageMouseUpHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
			
			startX = mouseX;
			startY = mouseY;
			lastX = mouseX;
			lastY = mouseY;
			
			if (brush.type == BrushType.BRUSH)
			{
				
				blurFilter.blurX = 0;
				
				blurFilter.blurY = 0;
				
				graphicMovie.filters = new Array(blurFilter);
				
				graphicMovie.visible=true;
				
				graphicMovie.graphics.lineStyle(brush.percent * MAX_THICKNESS, brush.color, 1, true, LineScaleMode.NONE, CapsStyle.ROUND);
				
				graphicMovie.graphics.moveTo(mouseX, mouseY);
				
			}
			else if (brush.type == BrushType.AIR_BRUSH)
			{
				graphicMovie.visible=true;
				
				graphicMovie.filters = new Array(blurFilter);
				
				graphicMovie.graphics.lineStyle(brush.percent * MAX_THICKNESS, brush.color, 1, true, LineScaleMode.NONE, CapsStyle.ROUND);
				
				graphicMovie.graphics.moveTo(mouseX, mouseY);
			}
			else
			{
				blurFilter.blurX = 0;
				
				blurFilter.blurY = 0;
				
				graphicMovie.filters = new Array(blurFilter);
				
				graphicMovie.visible = false;
				
				graphicMovie.graphics.lineStyle(brush.percent * MAX_THICKNESS, brush.color);
				
				graphicMovie.graphics.moveTo(mouseX, mouseY);
				
			}
		}
		
		private function onRollOutHandler(e:MouseEvent):void 
		{
			
			this.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
		}
		
		private function stageMouseUpHandler(e:Event):void
		{
			
			
			this.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			
			this.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, stageMouseUpHandler);
			
			if (brush.type != BrushType.ERASER)
			{
					
				bmd.draw(graphicMovie, myMatrix,null, BlendMode.NORMAL, null, true);
				 
				graphicMovie.visible = false;
			}
			
			
		}
		
		private function stageMouseMoveHandler(e:MouseEvent):void
		{
			
			if (brush.type != BrushType.ERASER)
			{
				graphicMovie.graphics.lineTo(mouseX, mouseY);
				
				
			}
			else
			{
				
				graphicMovie.graphics.lineTo(mouseX, mouseY);
				
				bmd.draw(graphicMovie, null, null, BlendMode.ERASE,null,true);
				
			}
		
			e.updateAfterEvent();
			
		}
		
		
		public function clear():void
		{
			
			if (bmp != null)
			{
				removeChild(bmp);
				
				bmd = new BitmapData(numBorderW, numBorderH, true, 0);
				bmp = new Bitmap(bmd);
				addChild(bmp);
			}
		
		}
	
	}

}