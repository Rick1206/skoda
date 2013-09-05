package com.ctp.view.components.drawingboard {
	import com.ctp.view.components.photo.UploadPanel;
	import com.ctp.view.events.UploadPhotoEvent;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class UploadPhotoPopup extends UploadPanel {
		
		public var uploadedPhoto:Bitmap;
		
		public function UploadPhotoPopup() {
			visible = false;
			alpha = 0;
		}
		
		override protected function uploadPhotoButtonClickHandler(e:MouseEvent):void {
			fileRef.addEventListener(Event.COMPLETE, fileLoadedHandler);
			fileRef.load();
		}
		
		private function fileLoadedHandler(e:Event):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBytesHandler);
			loader.loadBytes(fileRef.data);
		}
		
		private function loadBytesHandler(e:Event):void {
			var loaderInfo:LoaderInfo = (e.currentTarget as LoaderInfo);
			loaderInfo.removeEventListener(Event.COMPLETE, loadBytesHandler);
			
			uploadedPhoto = loaderInfo.content as Bitmap;
			dispatchEvent(new UploadPhotoEvent(UploadPhotoEvent.COMPLETE));
		}
		
	}

}