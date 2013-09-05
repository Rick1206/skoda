package com.ctp.view.utils {
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ImageUtils {
		
		private static var callbackFunc: Function;
		private static var evt: Event;
		
		public static function validate(e: Event, callback: Function): void {
			var fileRef: FileReference = e.currentTarget as FileReference;
			callbackFunc = callback;
			evt = e;
			fileRef.addEventListener(Event.COMPLETE, fileLoadedHandler);
			fileRef.load();
		}
		
		static private function fileLoadedHandler(e:Event):void {
			var fileRef: FileReference = e.currentTarget as FileReference;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBytesHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.loadBytes(fileRef.data);
		}
		
		static private function ioErrorHandler(e:IOErrorEvent):void {
			callbackFunc.call(null, false, evt);
		}
		
		static private function loadBytesHandler(e:Event):void {
			callbackFunc.call(null, true, evt);
		}
		
	}

}