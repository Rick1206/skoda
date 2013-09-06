package code
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import code.tool.RollTool;
	import flash.events.MouseEvent;
	import code.events.QuesEvent;
	
	import com.greensock.TweenMax;
	
	public class question extends MovieClip
	{
		
		private var strTalent:String = "";
		private var strInspire:String = "";
		private var boolEnable:Boolean = true;
		private var btnTArr:Array;
		private var btnIArr:Array;
		
		public function question()
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
			
			//inspireMc.visible = false;
			//inspireMc.alpha = 0;
			
			
			talentMc.visible = false;
			talentMc.alpha = 0;
			
			
			btnTArr = [talentMc.c1, talentMc.c2, talentMc.c3];
			
			for (var i:int = 0; i < btnTArr.length; i++)
			{
				btnTArr[i].addEventListener(MouseEvent.ROLL_OVER, onRollHandler);
				btnTArr[i].addEventListener(MouseEvent.ROLL_OUT, onRollHandler);
				btnTArr[i].addEventListener(MouseEvent.CLICK, onClickHandler);
				
				RollTool.setRoll(btnTArr[i]);
			}
			
			btnIArr = [inspireMc.i1, inspireMc.i2, inspireMc.i3, inspireMc.i4, inspireMc.i5, inspireMc.i6];
			
			for (i = 0; i < btnIArr.length; i++)
			{
				
				btnIArr[i].addEventListener(MouseEvent.ROLL_OVER, onRollHandler);
				btnIArr[i].addEventListener(MouseEvent.ROLL_OUT, onRollHandler);
				btnIArr[i].addEventListener(MouseEvent.CLICK, onClickHandler);
				btnIArr[i].content.gotoAndStop(i + 1);
				
				RollTool.setRoll(btnIArr[i]);
				
			}
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			if (!boolEnable)
			{
				return;
			}
			boolEnable = false;
			switch (e.currentTarget.name)
			{
				case "c1": 
					strTalent = "1";
					break;
				case "c2": 
					strTalent = "2";
					break;
				case "c3": 
					strTalent = "3";
					break;
				case "i1": 
					strInspire = "1";
					break;
				case "i2": 
					strInspire = "2";
					break;
				case "i3": 
					strInspire = "3";
					break;
				case "i4": 
					strInspire = "4";
					break;
				case "i5": 
					strInspire = "5";
					break;
				case "i6": 
					strInspire = "6";
					break;
			}
			
			checkClickState(e.currentTarget as MovieClip);
			
			checkState();
		
		}
		
		private function checkClickState(mc:MovieClip):void
		{
			
			var strName:String = mc.name;
			
			if (strName.indexOf("c") > -1)
			{
				
				for (var i:int = 0; i < btnTArr.length; i++)
				{
					if (strName == btnTArr[i].name)
					{
						TweenMax.to(btnTArr[i].bg, .3, {colorTransform: {tint: 0x4ba82e, tintAmount: 1}});
						TweenMax.to(btnTArr[i].content, .3, { colorTransform: { tint: 0xffffff, tintAmount: 1 }} );
						
						btnTArr[i].removeEventListener(MouseEvent.ROLL_OUT, onRollHandler);
						btnTArr[i].btn.gotoAndStop(2);
					}
					else
					{
						TweenMax.to(btnTArr[i].bg, .3, {colorTransform: {tint: 0x4ba82e, tintAmount: 0}});
						TweenMax.to(btnTArr[i].content, .3, { colorTransform: { tint: 0xffffff, tintAmount:0 }} );
						
						btnTArr[i].addEventListener(MouseEvent.ROLL_OUT, onRollHandler);
						btnTArr[i].btn.gotoAndStop(1);
					}
				}
				
			}
			else
			{
				
				for (i = 0; i < btnIArr.length; i++)
				{
					//trace(strName);
					//trace(btnIArr[i].name == strName);
					if (btnIArr[i].name == strName)
					{
						btnIArr[i].btn.gotoAndStop(2);
						//trace("suc");
					}
					else
					{
						
						btnIArr[i].btn.gotoAndStop(1);
						//mc.btn.gotoAndStop(1);
					}
				}
				
			}
		}
		
		public function show(str:String)
		{
			switch (str)
			{
				case "inspire": 
					TweenMax.to(inspireMc, .3, {autoAlpha: 1});
					TweenMax.to(talentMc, .3, {autoAlpha: 0});
					break;
				case "talent": 
					TweenMax.to(talentMc, .3, {autoAlpha: 1});
					TweenMax.to(inspireMc, .3, {autoAlpha: 0});
					break;
			}
		
		}
		
		private function checkState():void
		{
			if (strInspire != "" && strTalent != "")
			{
				var qEvent:QuesEvent = new QuesEvent("UPLOAD");
				
				qEvent.insprie = strInspire;
				qEvent.talent = strTalent;
				
				dispatchEvent(qEvent);
				
				boolEnable = true;
			}
			else
			{
				
				TweenMax.to(talentMc, .3, {autoAlpha: 1});
				TweenMax.to(inspireMc, .3, {autoAlpha: 0});
				
				boolEnable = true;
			}
		
		}
		
		private function onRollHandler(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case "rollOut":
					
					TweenMax.to(mc.bg, .3, {colorTransform: {tint: 0x4ba82e, tintAmount: 0}});
					TweenMax.to(mc.content, .3, {colorTransform: {tint: 0xffffff, tintAmount: 0}});
					mc.btn.gotoAndStop(1);
					break;
				case "rollOver":
					
					TweenMax.to(mc.bg, .3, {colorTransform: {tint: 0x4ba82e, tintAmount: 1}});
					TweenMax.to(mc.content, .3, {colorTransform: {tint: 0xffffff, tintAmount: 1}});
					mc.btn.gotoAndStop(2);
					
					break;
			}
		}
	
	}

}
