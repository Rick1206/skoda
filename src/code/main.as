package code {
	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	
	public class main extends MovieClip {
		
		
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
			mainContent.x = stage.stageWidth/2; 
			mainContent.y = stage.stageHeight / 2;
			stage.addEventListener(Event.RESIZE, updateStage);
		}
		
		private function updateStage(e:Event):void 
		{
			mainContent.x = stage.stageWidth/2; 
		}
	}
	
}
