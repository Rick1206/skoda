package com.ctp.view.components.drawingboard {
	
	import com.ctp.view.components.photo.UploadPanel;
	import com.ctp.view.events.UploadPhotoEvent;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	
	import com.greensock.TweenMax;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class UploadPhotoPopup extends UploadPanel {
		
		private static var _instance:UploadPhotoPopup;
		public var uploadedPhoto:Bitmap;
		private var _stage:Sprite;
		private var _status:String = "fir";
		
		private var _type:String;
		public function UploadPhotoPopup(singleton:Singleton) {
			if (singleton == null){
				throw new Error("ConfirmBox is a singleton class.  ConfirmBox via ''ConfirmBox.instance''.");
			}
		}
		
		public function init():void {
			visible = false;
			alpha = 0;
			if (_status == "fir") {
				_stage.addChild(this);
				closeButton.addEventListener(MouseEvent.CLICK, onHideHandler);
				_status == "sec";
			}
		}
		
		private function onHideHandler(e:MouseEvent):void 
		{
			TweenMax.to(this, .2, { autoAlpha:0 } );
		}
		
		public function initStage($stage:Sprite):void {
			_stage = $stage;
			init();
		}
			
		override protected function uploadPhotoButtonClickHandler(e:MouseEvent):void {
			e.stopImmediatePropagation();
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
			
			var myUploadPhotoEvent:UploadPhotoEvent = new UploadPhotoEvent(UploadPhotoEvent.COMPLETE);
			
			myUploadPhotoEvent.ptype = this._type;
			
			dispatchEvent(myUploadPhotoEvent);
		}
		
		public static function get instance():UploadPhotoPopup {
 			if (UploadPhotoPopup._instance == null){
				UploadPhotoPopup._instance = new UploadPhotoPopup(new Singleton());
			}
 			return UploadPhotoPopup._instance;
 		}	
		
		public function get type():String 
		{
			return _type;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
	}
}
class Singleton { }