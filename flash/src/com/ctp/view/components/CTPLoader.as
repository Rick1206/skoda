package com.ctp.view.components {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class CTPLoader extends Sprite {
		
		public var progressMovie: ProgressUI = new ProgressUI();
		
		public function CTPLoader() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			progressMovie.percentText.text = "";
			progressMovie.x = stage.stageWidth / 2;
			progressMovie.y = stage.stageHeight / 2;
			addChild(progressMovie);
			
			if (loaderInfo.parameters.url) {
				var loader: Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				loader.load(new URLRequest(loaderInfo.parameters.url));
			}
		}
		
		private function completeHandler(e:Event):void {
			var loaderInfo: LoaderInfo = e.currentTarget as LoaderInfo;
			addChild(loaderInfo.content);
			removeChild(progressMovie);
		}
		
		private function progressHandler(e:ProgressEvent):void {
			var percent: int = Math.round((e.bytesLoaded * 100) / e.bytesTotal);
			progressMovie.percentText.text = percent + "%";
			progressMovie.percentMovie.gotoAndStop(percent);
		}
		
	}

}