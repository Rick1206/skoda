package com.ctp.view.components.drawingboard.resizing
{
	//object-type
	import com.ctp.model.constant.ObjectType;
	//why
	import com.ctp.model.vo.FontTypeInfo;
	//
	import com.ctp.view.components.drawingboard.ResizingUI;
	import com.ctp.view.events.ObjectResizingEvent;
	
	import com.pyco.external.JSBridge;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.ui.Keyboard;
	
	import code.tool.RollTool;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	
	public class ObjectResizing extends ResizingUI
	{
		
		public static const MAX_WIDTH:uint = 640;
		public static const MAX_HEIGHT:uint = 446;
		
		private var _type:String = "";
		
		protected var contentPadding:uint = 6;
		protected var minWidth:uint = 64;
		protected var minHeight:uint = 110;
		
		private var mouseDownPosX:Number;
		private var mouseDownPosY:Number;
		
		private var selectedDot:Sprite;
		private var selectedRot:SimpleButton;
		private var startRotation:Number;
		private var oldRotation:Number;
		private var keepDot:Sprite;
		private var oldX:Number;
		private var oldY:Number;
		
		protected var isShowingTool:Boolean = false;
		protected var _color:uint;
		
		public function ObjectResizing()
		{
			borderMovie.mouseEnabled = false;
			showTool(false);
			contentMovie.addEventListener(MouseEvent.MOUSE_DOWN, contentMovieMouseDownHandler, false, 0, true);
			deleteButton.addEventListener(MouseEvent.MOUSE_DOWN, contentMovieMouseDownHandler, false, 0, true);
			deleteButton.addEventListener(MouseEvent.CLICK, deleteButtonClickHandler, false, 0, true);
			
			RollTool.setRoll(deleteButton);
			
			var i:int;
			for (i = 1; i <= 8; i++)
			{
				var dotMovie:MovieClip = getChildByName("dot" + i) as MovieClip;
				dotMovie.buttonMode = true;
				dotMovie.addEventListener(MouseEvent.MOUSE_DOWN, dotMouseDownHandler, false, 0, true);
			}
			for (i = 1; i <= 4; i++)
			{
				getChildByName("rot" + i).addEventListener(MouseEvent.MOUSE_DOWN, rotationMouseDownHandler, false, 0, true);
			}
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		}
		
		public function setTextFormat(data:FontTypeInfo):void
		{
		
		}
		
		private function removeFromStageHandler(e:Event):void
		{
			
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function keyDownHandler(e:KeyboardEvent):void
		{
			if (borderMovie.visible && e.keyCode == Keyboard.DELETE)
			{
				dispatchEvent(new ObjectResizingEvent(ObjectResizingEvent.DELETE));
			}
		}
		
		private function calculateAngle(stageX:Number, stageY:Number):Number
		{
			var p:Point = parent.globalToLocal(new Point(stageX, stageY));
			
			var p1:Point = this.localToGlobal(new Point(deleteButton.x, deleteButton.y));
			p1 = parent.globalToLocal(p1);
			
			p.x -= p1.x;
			p.y -= p1.y;
			
			if (p.x == 0)
			{
				if (p.y > 0)
				{
					return 90;
				}
				else
				{
					return 270;
				}
			}
			else
			{
				var rad:Number = Math.atan(p.y / p.x);
				rad = rad * 180 / Math.PI;
				
				if ((p.x <= 0 && p.y >= 0) || (p.x <= 0 && p.y <= 0))
				{
					rad = 180 + rad;
				}
				else if (p.x >= 0 && p.y <= 0)
				{
					rad = 360 + rad;
				}
				
				return rad;
			}
			
			return 0;
		}
		
		private function rotationMouseDownHandler(e:MouseEvent):void
		{
			selectedRot = e.currentTarget as SimpleButton;
			startRotation = calculateAngle(e.stageX, e.stageY);
			oldRotation = this.rotation;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageRotateMouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageRotateMouseUpHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, stageRotateMouseUpHandler);
		}
		
		private function stageRotateMouseMoveHandler(e:MouseEvent):void
		{
			var newRotation:Number = calculateAngle(e.stageX, e.stageY);
			this.rotation = oldRotation + (newRotation - startRotation);
			e.updateAfterEvent();
		}
		
		private function stageRotateMouseUpHandler(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageRotateMouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageRotateMouseUpHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, stageRotateMouseUpHandler);
		}
		
		protected function dotMouseDownHandler(e:MouseEvent):void
		{
			selectedDot = e.currentTarget as Sprite;
			switch (selectedDot)
			{
				case dot1: 
				case dot2: 
					keepDot = dot5;
					break;
				case dot3: 
					keepDot = dot7;
					break;
				case dot4: 
				case dot5: 
				case dot6: 
					keepDot = dot1;
					break;
				case dot7: 
				case dot8: 
					keepDot = dot3;
					break;
			}
			var p:Point = new Point(keepDot.x, keepDot.y);
			p = localToGlobal(p);
			
			mouseDownPosX = p.x;
			mouseDownPosY = p.y;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageScaleMouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageScaleMouseUpHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, stageScaleMouseUpHandler);
		}
		
		private function stageScaleMouseUpHandler(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageScaleMouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageScaleMouseUpHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, stageScaleMouseUpHandler);
		}
		
		private function stageScaleMouseMoveHandler(e:MouseEvent):void
		{
			var newWidth:Number = getWidth();
			var newHeight:Number = getHeight();
			var distanceX:Number = 0;
			var distanceY:Number = 0;
			switch (selectedDot)
			{
				case dot1: 
					distanceX = selectedDot.x - this.mouseX;
					distanceY = selectedDot.y - this.mouseY;
					break;
				case dot2: 
					distanceY = selectedDot.y - this.mouseY;
					break;
				case dot3: 
					distanceX = this.mouseX - selectedDot.x;
					distanceY = selectedDot.y - this.mouseY;
					break;
				case dot4: 
					distanceX = this.mouseX - selectedDot.x;
					break;
				case dot5: 
					distanceX = this.mouseX - selectedDot.x;
					distanceY = this.mouseY - selectedDot.y;
					break;
				case dot6: 
					distanceY = this.mouseY - selectedDot.y;
					break;
				case dot7: 
					distanceX = selectedDot.x - this.mouseX;
					distanceY = this.mouseY - selectedDot.y;
					break;
				case dot8: 
					distanceX = selectedDot.x - this.mouseX;
					break;
			}
			if (distanceX != 0 && newWidth + distanceX < minWidth)
			{
				distanceX = 0;
			}
			if (distanceY != 0 && newHeight + distanceY < minHeight)
			{
				distanceY = 0;
			}
			if (distanceX == 0 && distanceY == 0)
			{
				return;
			}
			
			setWidth(newWidth + distanceX);
			setHeight(newHeight + distanceY);
			renderTransformTool();
			
			var p:Point = new Point(keepDot.x, keepDot.y);
			p = localToGlobal(p);
			this.x -= p.x - mouseDownPosX;
			this.y -= p.y - mouseDownPosY;
			
			e.updateAfterEvent();
		}
		
		public function renderTransformTool():void
		{
			borderMovie.width = getWidth() + contentPadding;
			borderMovie.height = getHeight() + contentPadding;
			var bounds:Rectangle = borderMovie.getBounds(this);
			dot1.x = bounds.x;
			dot1.y = bounds.y;
			dot2.x = int(bounds.x + (bounds.width / 2));
			dot2.y = dot1.y;
			dot3.x = bounds.x + bounds.width;
			dot3.y = dot1.y;
			dot4.x = dot3.x;
			dot4.y = int(bounds.y + (bounds.height / 2));
			dot5.x = dot3.x;
			dot5.y = bounds.y + bounds.height;
			dot6.x = dot2.x;
			dot6.y = dot5.y;
			dot7.x = dot1.x;
			dot7.y = dot5.y;
			dot8.x = dot1.x;
			dot8.y = dot4.y;
			rot1.x = dot1.x;
			rot1.y = dot1.y;
			rot2.x = dot3.x;
			rot2.y = dot3.y;
			rot3.x = dot5.x;
			rot3.y = dot5.y;
			rot4.x = dot7.x;
			rot4.y = dot7.y;
		}
		
		protected function deleteButtonClickHandler(e:MouseEvent):void
		{
			if (mouseDownPosX == stage.mouseX && mouseDownPosY == stage.mouseY)
			{
				dispatchEvent(new ObjectResizingEvent(ObjectResizingEvent.DELETE));
			}
		}
		
		protected function contentMovieMouseDownHandler(e:MouseEvent):void
		{
			
			mouseDownPosX = stage.mouseX;
			mouseDownPosY = stage.mouseY;
			if (borderMovie.visible == false)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, stageObjectMouseUpHandler);
				return;
			}
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, stageMouseUpHandler);
			oldX = this.x;
			oldY = this.y;
		}
		
		private function stageObjectMouseUpHandler(e:MouseEvent):void
		{
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageObjectMouseUpHandler);
			if (stage.mouseX == mouseDownPosX && stage.mouseY == mouseDownPosY)
			{
				dispatchEvent(new ObjectResizingEvent(ObjectResizingEvent.CLICK));
			}
		}
		
		private function stageMouseMoveHandler(e:MouseEvent):void
		{
			
			var _w:Number = (this.width / 2) - 20;
			var _h:Number = (this.height / 2) - 20;
			
			if (this.x < -_w)
			{
				this.x = -_w+5;
				stageMouseUpHandler(null);
				return;
			}
			else if (this.x > 624 + _w)
			{
				this.x = 624 + _w - 5;
				stageMouseUpHandler(null);
				return;
			}
			else if (this.y < -_h)
			{
				this.y = -_h+5;
				stageMouseUpHandler(null);
				return;
			}
			else if (this.y > 624+_h)
			{
				this.y = 624 + _h - 15;
				stageMouseUpHandler(null);
				return;
			}
			
			this.x = oldX + stage.mouseX - mouseDownPosX;
			this.y = oldY + stage.mouseY - mouseDownPosY;
			
			e.updateAfterEvent();
		
		}
		
		private function stageMouseUpHandler(e:MouseEvent):void
		{
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, stageMouseUpHandler);
			if (this.hitTestPoint(stage.mouseX, stage.mouseY))
			{
				dispatchEvent(new ObjectResizingEvent(ObjectResizingEvent.CLICK));
			}
		}
		
		public function showTool(flag:Boolean = true):void
		{
			if (isShowingTool == flag)
			{
				return;
			}
			isShowingTool = flag;
			for (var i:int = 0; i < this.numChildren; i++)
			{
				if (this.getChildAt(i) != contentMovie)
				{
					this.getChildAt(i).visible = flag;
					this.getChildAt(i)["mouseEnabled"] = flag;
				}
			}
		}
		
		public function setWidth(value:Number):void
		{
		
		}
		
		public function setHeight(value:Number):void
		{
		
		}
		
		public function getWidth():Number
		{
			return 0;
		}
		
		public function getHeight():Number
		{
			return 0;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
			switch (value)
			{
				case ObjectType.CLIPART: 
					JSBridge.call("trackClipart");
					break;
				case ObjectType.IMAGE: 
					JSBridge.call("trackUpload");
					break;
				case ObjectType.TEXT: 
					JSBridge.call("trackTextbox");
					break;
			}
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			_color = value;
		}
	
	}

}