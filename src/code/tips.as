package code
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import code.tool.RollTool;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import com.greensock.TweenMax;
	
	public class tips extends MovieClip
	{
		
		private var numTipsNum:int = 1;
		private var btnArr:Array;
		private var contentArr:Array;
		private var curContentMc:MovieClip;
		private var myTimer:Timer;
		
		private var strFir:String;
		
		public function tips()
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
			
			btnArr = [btnTip1, btnTip2, btnTip3];
			contentArr = [developMc, serviceMc, scienceMc];
			
			for (var key:String in btnArr)
			{
				RollTool.setRoll(btnArr[key]);
				btnArr[key].addEventListener(MouseEvent.CLICK, onClickHandler);
				
				btnArr[key].addEventListener(MouseEvent.ROLL_OUT, onStopTimerHandler);
				btnArr[key].addEventListener(MouseEvent.ROLL_OVER, onStopTimerHandler);
				
				btnArr[key].addEventListener(MouseEvent.ROLL_OUT, onRollHandler);
				btnArr[key].addEventListener(MouseEvent.ROLL_OVER, onRollHandler);
			}
			
			status("develop");
		}
		
		private function onStopTimerHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case "rollOut":
					
					if (myTimer != null)
					{
						myTimer.start();
						trace("restart");
					}
					break;
				case "rollOver": 
					if (myTimer != null)
					{
						trace("stop");
						myTimer.stop();
						myTimer.reset();
					}
					break;
			}
		}
		
		private function onRollHandler(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case "rollOut": 
					mc.gotoAndStop(1);
					
					break;
				case "rollOver": 
					mc.gotoAndStop(2);
					break;
			}
		}
		
		public function status(str:String)
		{
			
			switch (str)
			{
				case "develop": 
					curContentMc = developMc;
					break;
				case "service": 
					curContentMc = serviceMc;
					break;
				case "science": 
					curContentMc = scienceMc;
					
					break;
			}
			
			for (var key:String in contentArr)
			{
				if (curContentMc.name == contentArr[key].name)
				{
					contentArr[key].visible = true;
				}
				else
				{
					contentArr[key].visible = false;
				}
			}
			
			numTipsNum = 1;
			strFir = "fir";
			
			if (myTimer != null)
			{
				myTimer.stop();
				myTimer = null;
			}
			btnArr[numTipsNum - 1].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			var str:String = e.currentTarget.name;
			switch (str)
			{
				case "btnTip1": 
					numTipsNum = 1;
					break;
				case "btnTip2": 
					numTipsNum = 2;
					break;
				case "btnTip3": 
					numTipsNum = 3;
					break;
			}
			
			for (var key:String in btnArr)
			{
				if (btnArr[key].name == str)
				{
					btnArr[key].gotoAndStop(2);
					btnArr[key].removeEventListener(MouseEvent.ROLL_OUT, onRollHandler);
					btnArr[key].removeEventListener(MouseEvent.ROLL_OVER, onRollHandler);
					
				}
				else
				{
					btnArr[key].gotoAndStop(1);
					btnArr[key].addEventListener(MouseEvent.ROLL_OUT, onRollHandler);
					btnArr[key].addEventListener(MouseEvent.ROLL_OVER, onRollHandler);
				}
			}
			
			if (myTimer == null)
			{
				myTimer = new Timer(4000, 0);
				
				myTimer.addEventListener(TimerEvent.TIMER, onTimerHandler);
				myTimer.start();
				
			}
			
			if (strFir == "fir")
			{
				curContentMc.gotoAndStop(numTipsNum);
				curContentMc.x = 100;
				curContentMc.alpha = 0;
				
				TweenMax.to(curContentMc, 0.5, {delay: 0.3, x: 0, alpha: 1});
				strFir = "sec";
			}
			else
			{
				
				TweenMax.to(curContentMc, 0.5, {x: -100, alpha: 0, onComplete: function()
					{
						
						curContentMc.gotoAndStop(numTipsNum);
						curContentMc.x = 100;
						curContentMc.alpha = 0;
						
						TweenMax.to(curContentMc, 0.5, {delay: 0.3, x: 0, alpha: 1});
					
					}});
			}
		
		}
		
		private function onTimerHandler(e:TimerEvent):void
		{
			
			numTipsNum++;
			if (numTipsNum > 3)
			{
				numTipsNum = 1;
			}
			
			btnArr[numTipsNum - 1].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		
		}
	
	}

}
