package code {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import code.tool.RollTool;
	import code.GlobalVars;
	
	public class itemque extends MovieClip {
		
		private var _ans:String;
		
		private var queArr:Array;
		private var qname:String;
		public function itemque() {
			// constructor code
			if (stage) {
				init();
			}else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
		}
		
		public function initData(str:String) {
			trace("init: "+str);
			
			qname = str;
			
			queArr = [q1, q2, q3, q4];
	
			for (var key:String in queArr) {
				RollTool.setRoll(queArr[key]);
				queArr[key].addEventListener(MouseEvent.CLICK, onClickHandler);
			}
		}
		private function onClickHandler(e:MouseEvent):void 
		{
			
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			switch(e.currentTarget.name) {
				case "q1":
					_ans = "A";
					break;
				case "q2":
					_ans = "B";
					break;
				case "q3":
					_ans = "C";
					break;
				case "q4":
					_ans = "D";
					break;
			}
			
			
			
			switch(qname) {
				case "q1":
					GlobalVars.setQ1(_ans);
					break;
				case "q2":
					GlobalVars.setQ2(_ans);
					break;
				case "q3":
					GlobalVars.setQ3(_ans);
					break;
				case "q4":
					GlobalVars.setQ4(_ans);
					break;
				case "q5":
					GlobalVars.setQ5(_ans);
					break;
			}
			
			
			
			
				for (var key:String in queArr) {
					
					if (queArr[key].name == mc.name) {
						queArr[key].gotoAndStop(2);
					}else {
						queArr[key].gotoAndStop(1);
					}
				
				}
			
		}
		
		public function get ans():String 
		{
			return _ans;
		}
		
		public function set ans(value:String):void 
		{
			_ans = value;
		}
	}
	
}
