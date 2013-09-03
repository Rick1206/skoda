package com.ctp.view.components.submitinspire {
	import com.ctp.view.components.photo.UploadPanel;
	import com.ctp.view.events.UploadPhotoEvent;
	import com.ctp.view.utils.ImageUtils;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class UploadInspirePhoto extends UploadPanel {
		
		public var uploadURL: String = "";
		public var receivedData: String = "";
		
		public function UploadInspirePhoto() {
			progressMovie.percentText.text = "";
		}
		
		public function validateImageCallbackHandler(result: Boolean, e: Event): void {
			if (result) {
				super.fileRefSelectHandler(e);
			} else {
				reset();
			}
		}
		
		override protected function fileRefSelectHandler(e:Event):void {
			ImageUtils.validate(e, validateImageCallbackHandler);
		}
		
		override protected function uploadPhotoButtonClickHandler(e:MouseEvent):void {
			if (uploadURL == null || uploadURL == "") {
				return;
			}
			
			uploadMovie.visible = false;
			progressMovie.visible = true;
			
			fileRef.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            fileRef.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            fileRef.addEventListener(Event.COMPLETE, completeHandler);
			fileRef.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
			
			var request: URLRequest = new URLRequest(uploadURL);
			request.method = URLRequestMethod.POST;
			fileRef.upload(request);
		}
		
		private function uploadCompleteDataHandler(e:DataEvent):void {
			receivedData = e.data;
			dispatchEvent(new UploadPhotoEvent(UploadPhotoEvent.COMPLETE));
		}
		
		private function completeHandler(e:Event):void {
		}
		
		private function progressHandler(e:ProgressEvent):void {
			var percent: int = Math.round(e.bytesLoaded * 100 / e.bytesTotal);
			progressMovie.percentText.text = percent + "%";
			progressMovie.percentMovie.gotoAndStop(percent);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			
		}
		
	}

}