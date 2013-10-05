package code
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import code.tool.RollTool;
	import code.GlobalVars;
	
	public class itemque extends MovieClip
	{
		
		private var _ans:String;
		
		public var queArr:Array;
		private var _qid:String;
		private var _oid:String;
		
		public function itemque()
		{
			// constructor code
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			queArr = [q1, q2, q3, q4];
			
			
			for (var key:String in queArr)
			{
				RollTool.setRoll(queArr[key]);
				queArr[key].addEventListener(MouseEvent.CLICK, onClickHandler);
			}
		}
		
		
		private function onClickHandler(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			_oid = mc.num;
					
			for (var key:String in queArr)
			{
				
				if (queArr[key].name == mc.name)
				{
					queArr[key].gotoAndStop(2);
				}
				else
				{
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
			queArr[int(_ans) - 1].gotoAndStop(2);
		}
		
		public function get qid():String 
		{
			return _qid;
		}
		
		public function set qid(value:String):void 
		{
			_qid = value;
		}
		
		public function get oid():String 
		{
			return _oid;
		}
		
		public function set oid(value:String):void 
		{
			_oid = value;
		}
	
	}

}
