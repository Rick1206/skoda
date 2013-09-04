package code {
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	
	public class preloader extends MovieClip {
		
		private var percent: int ;
		private var mainMc:MovieClip;
		
		public function preloader() {
			// constructor code
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			if (stage) {
				init();
			}else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
			
		}
		
		private function init(e:Event=null):void 
		{
			
			mcLoading.x = stage.stageWidth / 2;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var strSwfName:String = loaderInfo.parameters.url ? loaderInfo.parameters.url : "draw.swf";
			
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.load(new URLRequest(strSwfName));
			
			stage.addEventListener(Event.RESIZE, updateStage);
			
		}
		
		private function updateStage(e:Event):void 
		{
			mcLoading.x = stage.stageWidth / 2;
		}
		
		private function completeHandler(e:Event):void 
		{
			mainMc = e.currentTarget.content as MovieClip;
			
			addChild(mainMc);
			
			removeChild(mcLoading);
		}
		
		private function progressHandler(e:ProgressEvent):void 
		{
			percent = Math.round((e.bytesLoaded * 100) / e.bytesTotal);
			mcLoading.percentText.text = percent + "%";
			mcLoading.percentMovie.gotoAndStop(percent);
		}
		
		
	}
	
}
