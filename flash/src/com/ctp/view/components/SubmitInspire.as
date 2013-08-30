package com.ctp.view.components {
	import com.ctp.view.components.submitinspire.UploadInspirePhoto;
	import com.ctp.view.events.UploadPhotoEvent;
	import com.pyco.external.JSBridge;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class SubmitInspire extends Sprite {
		
		public var uploadPanel: UploadInspirePhoto = new UploadInspirePhoto();
		
		public function SubmitInspire() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			uploadPanel.addEventListener(UploadPhotoEvent.COMPLETE, uploadPhotoCompleteHandler);
			uploadPanel.closeButton.addEventListener(MouseEvent.CLICK, closeButtonClickHandler);
			
			uploadPanel.uploadURL = loaderInfo.parameters.uploadURL;
			uploadPanel.x = - uploadPanel.bgMovie.x + 1;
			uploadPanel.y = - uploadPanel.bgMovie.y + (uploadPanel.closeButton.height / 2);
			uploadPanel.reset();
			addChild(uploadPanel);
		}
		
		private function closeButtonClickHandler(e:MouseEvent):void {
			JSBridge.call("closePanel");
		}
		
		private function uploadPhotoCompleteHandler(e:UploadPhotoEvent):void {
			JSBridge.call("uploadPhotoComplete", uploadPanel.receivedData);
		}
		
	}

}