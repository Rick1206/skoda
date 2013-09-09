package code {
	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	
	public class main extends MovieClip {
		
		private var tracker:AnalyticsTracker;
		
		public function main() {
			if (stage) {
				init();
			}else {
				addEventListener(Event.ADDED_TO_STAGE, init);
					
			}
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			tracker  = new GATracker( this, "UA-34374356-3", "AS3", false );
			
			try {
				tracker.trackPageview( "/idea-submission-flash");
			}catch(error:Error){
				trace(error);
			}
			
			mainContent.x = stage.stageWidth/2; 
			//mainContent.y = stage.stageHeight/2;
			stage.addEventListener(Event.RESIZE, updateStage);
		}
		
		private function updateStage(e:Event):void 
		{
			mainContent.x = stage.stageWidth/2; 
		}
	}
	
}
