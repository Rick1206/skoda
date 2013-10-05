package asfiles.utils

{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Rectangle;
	import asfiles.events.SliderEvent;
	import asfiles.events.PlayerEvent;
	
	public class Slider extends Sprite
	
	{
		
		public var thumb_mc:MovieClip;
		public var mask_mc:MovieClip;
		public var dragRectangle:Rectangle;
		
		private var __nRatio:Number;
		private var __nWidth:Number;
		private var __nValue:Number;
		private var __nMax:int;
		
		public function Slider ( pX:Number , pY:Number, pMax:int )
		
		{
			
			thumb_mc.buttonMode = true;
			
			__nMax = pMax, __nWidth = width;
			
			x = Math.round ( pX ), y = Math.round ( pY );
			
			dragRectangle = new Rectangle (0, thumb_mc.y, width-thumb_mc.width, 0)
			
			addEventListener (MouseEvent.MOUSE_DOWN, onThumbPress, true );
			
		}
		
		private function onThumbPress ( pEvt:MouseEvent ):void 
		
		{
			
			stage.addEventListener (MouseEvent.MOUSE_UP, onThumbUp);
			
			stage.addEventListener (MouseEvent.MOUSE_MOVE, onMouseMovin);
			
		}
		
		private function onMouseMovin ( pEvt:MouseEvent ):void 
		
		{
			
			thumb_mc.startDrag ( false, dragRectangle );
			
			var ratio:Number = (thumb_mc.x /(__nWidth-thumb_mc.width));
			
			__nValue = ( __nMax == 1  ) ? ratio : Math.round ( ratio * __nMax );

			
			updateUI();
			
			dispatchEvent ( new SliderEvent (SliderEvent.CHANGE, __nValue) );
			
		}
		
		private function updateUI():void 
		{
			mask_mc.width = thumb_mc.x+thumb_mc.width/2;
		}
		
		private function onThumbUp ( pEvt:MouseEvent ):void 
		
		{
			stage.removeEventListener (MouseEvent.MOUSE_UP, onThumbUp);
			
			stage.removeEventListener (MouseEvent.MOUSE_MOVE, onMouseMovin);
			
			thumb_mc.stopDrag ();
			
			dispatchEvent ( new Event (MouseEvent.MOUSE_UP) );
			
		}
		
		public function set value ( pValue:Number ):void 
		
		{
			
			pValue = __nValue = Math.min ( __nMax, Math.max ( 0, pValue) );	
			
			thumb_mc.x = Math.round ( pValue * ( (__nWidth - thumb_mc.width) / __nMax) );
			
			updateUI();
		}
		
		public function get value ():Number 
		
		{
			
			return __nValue;
			
			
			
		}
		
		public function get maximum ( ):int
		
		{
			
			return __nMax;
			
		}
		
		public function set maximum ( pMaximum:int ):void
		
		{
			
			__nMax = pMaximum;
			
		}
		
	}
	
}