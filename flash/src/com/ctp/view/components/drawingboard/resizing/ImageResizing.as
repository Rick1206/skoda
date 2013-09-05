package com.ctp.view.components.drawingboard.resizing {
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
	public class ImageResizing extends ObjectResizing {
		
		private var contentBitmap: Bitmap;
		public var defaultWidth: int = 0;
		
		public function ImageResizing() {
			removeChild(closeButton);
			contentMovie.removeChild(contentMovie.inputText);
		}
		
		public function load(url: String): void {
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load(new URLRequest(url));
		}
		
		private function loaderCompleteHandler(e:Event):void {
			var loaderInfo: LoaderInfo = e.currentTarget as LoaderInfo;
			setImage(loaderInfo.content as Bitmap);
		}
		
		public function setImage(bm: Bitmap): void {
			contentBitmap = bm;
			bm.smoothing = true;
			if (defaultWidth == 0) {
				if (bm.width > ObjectResizing.MAX_WIDTH || bm.height > ObjectResizing.MAX_HEIGHT) {
					var scaleDown: Number = Math.min(ObjectResizing.MAX_WIDTH / bm.width, ObjectResizing.MAX_HEIGHT / bm.height);
					bm.scaleX = bm.scaleY = scaleDown;
				} else {
					if (bm.width < minWidth || bm.height < minHeight) {
						var scaleUp: Number = Math.max(minWidth / bm.width, minHeight / bm.height);
						bm.scaleX = bm.scaleY = scaleUp;
					}
				}
			} else {
				bm.width = defaultWidth;
				bm.scaleY = bm.scaleX;
			}
			bm.x = -bm.width / 2;
			bm.y = -bm.height / 2;
			contentMovie.loadingMovie.stop();
			contentMovie.removeChild(contentMovie.loadingMovie);
			contentMovie.addChild(bm);
			renderTransformTool();
			isShowingTool = true;
		}
		
		override public function setWidth(value:Number):void {
			if (contentBitmap == null) {
				return;
			}
			contentBitmap.width = value;
			contentBitmap.x = -contentBitmap.width / 2;
		}
		
		override public function setHeight(value:Number):void {
			if (contentBitmap == null) {
				return;
			}
			contentBitmap.height = value;
			contentBitmap.y = -contentBitmap.height / 2;
		}
		
		override public function getWidth():Number {
			if (contentBitmap == null) {
				return contentMovie.width;
			}
			return contentBitmap.width;
		}
		
		override public function getHeight():Number {
			if (contentBitmap == null) {
				return contentMovie.width;
			}
			return contentBitmap.height;
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			
		}
		
	}

}