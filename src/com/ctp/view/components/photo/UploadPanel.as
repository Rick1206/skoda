package com.ctp.view.components.photo
{
	
	import com.ctp.view.components.drawingboard.UploadPhotoUI;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextField;
	import code.tool.RollTool;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class UploadPanel extends UploadPhotoUI
	{
		
		public var dotMovie:MovieClip;
		public var messageMovie:MovieClip;
		public var browseButton:MovieClip;
		public var uploadPhotoButton:MovieClip;
		public var filenameText:TextField;
		
		protected var fileRef:FileReference;
		protected var typeFilter:Array = [];
		
		protected var colorTransform:ColorTransform = new ColorTransform();
		
		public function UploadPanel()
		{
			
			progressMovie.visible = false;
			
			dotMovie = uploadMovie.dotMovie;
			messageMovie = uploadMovie.messageMovie;
			browseButton = uploadMovie.browseButton;
			uploadPhotoButton = uploadMovie.uploadPhotoButton;
			filenameText = uploadMovie.filenameText;
			
			var allTypeFilter:FileFilter = new FileFilter("All Picture Files", "*.jpg;*.jpeg;*.gif;*.png");
			var jpgTypeFilter:FileFilter = new FileFilter("JPEG (*.jpg;*.jpeg)", "*.jpg;*.jpeg");
			var gifTypeFilter:FileFilter = new FileFilter("GIF (*.gif)", "*.gif");
			var pngTypeFilter:FileFilter = new FileFilter("PNG (*.png)", "*.png");
		
			typeFilter = [allTypeFilter, jpgTypeFilter, gifTypeFilter, pngTypeFilter];
			
			browseButton.addEventListener(MouseEvent.CLICK, browseButtonClickHandler);
			
			RollTool.setRoll(browseButton);
			RollTool.setRoll(uploadPhotoButton);
			RollTool.setRoll(closeButton);
			
			messageMovie.alpha = 0;
		}
		
		private function browseButtonClickHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			var fileReference:FileReference = new FileReference();
			fileReference.addEventListener(Event.SELECT, fileRefSelectHandler);
			//fileReference.addEventListener(
			fileReference.browse(typeFilter);
		}
		
		protected function fileRefSelectHandler(e:Event):void
		{
			fileRef = e.currentTarget as FileReference;
			reset();
			
			if (fileRef.size > 2 * 1024 * 1024)
			{
				messageMovie.alpha = 1;
				messageMovie.gotoAndStop(2);
				colorTransform.color = 0xFF0000;
				messageMovie.transform.colorTransform = colorTransform;
				return;
			}else {
				messageMovie.alpha = 0;
			}
			
			var imgType:Array = [".jpg", ".jpeg", ".gif", ".png"];
			var statusFormat:Boolean = false;
			for (var i:int = 0; i < imgType.length; i++) {
				if (fileRef.type == imgType[i]) {
					statusFormat = true;
				}
			}
			if (!statusFormat) {
				messageMovie.alpha = 1;
				messageMovie.gotoAndStop(1);
					colorTransform.color = 0xFF0000;
					messageMovie.transform.colorTransform = colorTransform;
					return;
			}else {
				messageMovie.alpha = 0;
			}
			
			dotMovie.visible = false;
			filenameText.text = fileRef.name;
			uploadPhotoButton.addEventListener(MouseEvent.CLICK, uploadPhotoButtonClickHandler);
			
			
		}
		
		protected function uploadPhotoButtonClickHandler(e:MouseEvent):void
		{
		
		}
		
		public function reset():void
		{
			//colorTransform.color = 0x898989;
			//messageMovie.transform.colorTransform = colorTransform;
			
			progressMovie.visible = false;
			dotMovie.visible = true;
			filenameText.text = "";
			
			uploadPhotoButton.removeEventListener(MouseEvent.CLICK, uploadPhotoButtonClickHandler);
		}
	
	}

}

