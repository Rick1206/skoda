package code {
	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	
	public class main extends MovieClip {
		
		
		public function main() {
			// constructor code
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			
			mainContent.x = stage.stageWidth/2; 
			//mainContent.y = stage.stageHeight / 2; 
			stage.addEventListener(Event.RESIZE, updateRoseStage);
		}
		
		private function updateRoseStage(e:Event):void 
		{
			mainContent.x = stage.stageWidth/2; 
		}
	}
	
}
