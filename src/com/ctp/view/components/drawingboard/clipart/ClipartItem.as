package com.ctp.view.components.drawingboard.clipart {
	import com.ctp.model.vo.ClipartInfo;
	import com.ctp.view.events.ClipartEvent;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ClipartItem extends Sprite {
		
		private const MAX_WIDTH: uint = 100;
		public var bitmap:Bitmap;
		public var data: ClipartInfo = new ClipartInfo();
		
		public function ClipartItem() {
			buttonMode = true;
			doubleClickEnabled = true;
		}
		
		public function load(): void {
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load(new URLRequest(data.thumb));
		}
		
		private function loaderCompleteHandler(e:Event):void {
			var loaderInfo: LoaderInfo = e.currentTarget as LoaderInfo;
			setImage(loaderInfo.content as Bitmap);
			dispatchEvent(new ClipartEvent(ClipartEvent.LOAD_IMAGE_COMPLETE));
		}
		
		public function setImage(bm: Bitmap): void {
			while (this.numChildren) {
				var oldBitmap: Bitmap = this.removeChildAt(0) as Bitmap;
				oldBitmap.bitmapData.dispose();
			}
			bitmap = bm;
			bitmap.smoothing = true;
			if (bitmap.width > MAX_WIDTH) {
				bitmap.width = MAX_WIDTH;
				bitmap.scaleY = bitmap.scaleX;
			}
			bitmap.x = int((MAX_WIDTH - bitmap.width) / 2);
			addChild(bitmap);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			dispatchEvent(new ClipartEvent(ClipartEvent.LOAD_IMAGE_ERROR));
		}
		
	}

}