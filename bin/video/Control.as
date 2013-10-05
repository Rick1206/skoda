package {
	 
	 
	import asfiles.events.MetaEvent;
	import asfiles.events.PlayerEvent;
	import asfiles.events.SliderEvent;
	import asfiles.utils.Player;
	import asfiles.utils.Slider;
	import com.zehfernando.display.drawPlane;
	import fl.video.MetadataEvent;
	import fl.video.VideoEvent;
	import fl.video.VideoState;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import code.GlobalVars;
	public class Control extends Sprite {
		private var shadow:Bitmap;
		private var loadingPecent:Number;
		private var cs:Array=[];
		private var c:C;
		private var frame:int;
		 
		private var coverVideo:MovieClip;
		private var pointContainer:Sprite;
		private var soundvalue:Number=.6;
		private var playprogress:Number;
		private var checkScreen:Boolean;
		private var timer:Timer;
		private var keyFrame:Number = 40;
		public var fullscreenBtn:Sprite;
		public var voiceSlider:Slider;
		public var playBtn:MovieClip;
		public var voiceIcon:MovieClip;
		public var bar:Sprite;
		public var loading:Sprite;
		public var flv:Player;
		public var cover:Sprite;
		public var index:int;
		public var trackingData:Object;
		public var waiting:MovieClip;

		public function Control():void {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			
			
			voiceSlider = new Slider(397, 36, 1);
			voiceSlider.addEventListener (SliderEvent.CHANGE, onSoundChangeHandler);
			addChild(voiceSlider);
			voiceSlider.value = soundvalue;
			
			
			
			bar['progress'].width = 1;
			voiceIcon.gotoAndStop(1);
			voiceIcon.buttonMode = true;
			voiceIcon.addEventListener(MouseEvent.CLICK, onClickSwitchSoundTransformHandler);
			voiceIcon['icon'].gotoAndStop(int(voiceSlider.value  / voiceSlider.maximum*10/3));
			//voiceSlider.visible = false;
			//voiceIcon.visible = false;
			
			playBtn.gotoAndStop(2);
			playBtn.buttonMode = true;
			playBtn.addEventListener(MouseEvent.CLICK, onClickPlayHandler);
			fullscreenBtn.buttonMode = true;
			fullscreenBtn.addEventListener(MouseEvent.CLICK, onClickHandler);
			showShadow();
			
			resize();
			
			flv.addEventListener(VideoEvent.READY, onReadyHandler);
			flv.addEventListener(PlayerEvent.ON_LOAD_PROGRESS, onLoadingHandler);
			flv.addEventListener (MetaEvent.ON_META, onMyMetaData);
			flv.addEventListener (PlayerEvent.ON_PROGRESS, onProgress);
			flv.addEventListener("waiting", onEnterCheckHandler);
			flv.addEventListener("ok", onEnterCheckHandler);
			flv.addEventListener(VideoEvent.COMPLETE, onPlayCompleteHandler);
			
			
			flv.bufferTime = 3;
			 
			stage.addEventListener(Event.RESIZE, onResizeHandler);
		}
		
		private function onSoundChangeHandler(e:SliderEvent):void 
		{
			flv.setVoice(voiceSlider.value);
			soundvalue = voiceSlider.value;
			if (voiceSlider.value == 0) {
				voiceIcon.gotoAndStop(2);
				
			}else {
				voiceIcon.gotoAndStop(1);
				voiceIcon['icon'].gotoAndStop(int(voiceSlider.value  / voiceSlider.maximum*10/3));
			}
			 
		}
		
		private function onEnterCheckHandler(e:Event):void 
		{
			switch(e.type) {
				case "ok":
					if (index == 2) {
						checkScreen = true;
						addEnterFrame();
					}
					break;
				case "waiting":
					 
					removeEnterFrame();
						 
					break;
			}
		}
		
		private function onMyMetaData ( pEvt:MetaEvent ):void 
		{	
			
		}

		private function onProgress ( pEvt:PlayerEvent ):void
		{
			//trace("progress:", pEvt.progress);
			
			playprogress = pEvt.progress;
			
			bar['progress'].width =  pEvt.progress * (stage.stageWidth-bar['progressBtn'].width/2);
			bar['progressBtn'].x =  pEvt.progress * (stage.stageWidth - bar['progressBtn'].width);
			
			 
					
					
		}
		private function onClickSwitchSoundTransformHandler(e:MouseEvent):void 
		{
			//var st:SoundTransform = new SoundTransform();
			switch(e.currentTarget.currentFrame) {
				case 1:
					//st.volume = 0;
					flv.setVoice(0);
					voiceSlider.value = 0;
					e.currentTarget.gotoAndStop(e.currentTarget.currentFrame % 2 + 1);
					break;
				case 2:
					//st.volume = soundvalue;
					flv.setVoice(soundvalue);
					voiceSlider.value = soundvalue;
					e.currentTarget.gotoAndStop(e.currentTarget.currentFrame % 2 + 1);
					voiceIcon['icon'].gotoAndStop(int(voiceSlider.value  / voiceSlider.maximum*10/3));
					break;
			}
			 
			
		}
		
		 
		
		 
		
		 
	 
		
		private function onEnterFrameHandler(e:Event):void 
		{
			
			/* if(checkScreen){
			
				var screen:BitmapData = new BitmapData(flv.width,flv.height, true, 0);
				 screen.draw(flv);
				
				// Debug.log(screen.getPixel(0, 0));
				  
				if (screen.getPixel(0, 0) ==16579836 ) {
					//Debug.log(screen.getPixel(0, 0));
					Debug.log("hide");
					var evt:MetadataEvent = new MetadataEvent(MetadataEvent.CUE_POINT);
					evt.info = { name:"endding"};// flv.addEventListener(MetadataEvent.CUE_POINT, onEnddingHandler);
					flv.dispatchEvent(evt);
					checkScreen = false;
				} 
				 
				 screen.dispose();
			
			}*/
			
			frame++;
			
			trace(GlobalVars.getTime());
			var myFrame:Number =  Math.round(GlobalVars.getTime() * 1000 / 40);
			
			if(index==2){
			var scale:Number = Math.min(stage.stageWidth / 540, (stage.stageHeight - 63) / 303);
			var flvWidth:Number = 540 * scale;
			var flvHeight:Number = 303 * scale;
			
			if(coverVideo){
				coverVideo.width = flvWidth;
				coverVideo.height = flvHeight;
				coverVideo.gotoAndStop(myFrame);
			
			}
			 
				
			for (var i:int = 0; i < trackingData.length; i++) {
				
				var _data:Array = trackingData[i];
				for (var j = 0; j < _data.length; j++ ) {
					if (_data[j].frame==myFrame) {
						//cs[i].visible=true;
						if (i > 1) {
							cs[i].x = _data[j].x* flvWidth/1280;
							cs[i].y = (_data[j].y+60) * flvWidth / 1280;
						}else {
							cs[i].x = _data[j].x* flvWidth/1280;
							cs[i].y = _data[j].y * flvWidth / 1280;
						}
						
						continue;
					}
				}
				
			}
				
				 if(ImageContainer.sourceBitmap){
				
					drawPlane(cover.graphics, ImageContainer.sourceBitmap, 
																		new Point(cs[0].x, cs[0].y),
																		new Point(cs[1].x, cs[1].y),
																		new Point(cs[2].x, cs[2].y),
																		new Point(cs[3].x, cs[3].y)
					);
				} 
			}
		}
		
		private function onLoadingHandler(e:*):void 
		{
			
			//loadingPecent = e.bytesTotal / e.bytesTotal;
			bar["loading"].width = flv.loadPencent * stage.stageWidth;
		}
		
		private function onReadyHandler(e:VideoEvent):void 
		{
			
			 
			if (index == 3) {
				cover.visible = false;
			}else{
				cover.visible = true;
			}
			trace("READY");
			 
			
			
			if (index == 2) {
				
				if (coverVideo == null) {
					var _class:Class = getDefinitionByName("CoverVideo") as Class;
					coverVideo = new _class();
					coverVideo.gotoAndStop(1);
					cover.addChild(coverVideo);
					//cover.addEventListener(Event.ENTER_FRAME, onUpdateHandler);
				}
				if (pointContainer == null) {
					pointContainer = new Sprite();
					cover.addChild(pointContainer);
					
					trace("trackingData.length:",trackingData.length);
					for (var i:int = 0; i < trackingData.length;i++){
						c = new C();
						cs[i] = c;
						
						c['id'].text = (i + 1).toString();
						c.x = trackingData[i][0].x;
						c.y = trackingData[i][0].y;
						c.visible = false;
						pointContainer.addChild(c);
						
				 
					}
					pointContainer.mouseChildren = pointContainer.mouseEnabled = false;
				}
			}
			
		}
		
	/*	private function onUpdateHandler(e:Event):void 
		{
			
			coverVideo.gotoAndStop(frame);
		}*/
		
		private function showShadow():void 
		{
			var _class:Class;
			try {
				_class = getDefinitionByName("Shadow" + index) as Class;
				shadow = new Bitmap(new _class(0, 0));
				cover.addChild(shadow);
			}catch (e:ReferenceError) {
				trace("")
			} 
			
		}
		
		private function onPlayCompleteHandler(e:VideoEvent):void 
		{
			playBtn.gotoAndStop(3);
			trace("totalframes:", frame);
			//ExternalInterface.call("alert",frame);
			checkScreen = false;
			if (index==2 ) {
				cover.visible = false;
				
				for (var i:int = 0; i < trackingData.length;i++){
					cs[i].x = trackingData[i][0].x;
					cs[i].y = trackingData[i][0].y;
				} 
				
				if(ImageContainer.sourceBitmap){				
					drawPlane(cover.graphics, ImageContainer.sourceBitmap, 
																		new Point(cs[0].x, cs[0].y),
																		new Point(cs[1].x, cs[1].y),
																		new Point(cs[2].x, cs[2].y),
																		new Point(cs[3].x, cs[3].y)
					);
				}
			}
			
			removeEnterFrame(true);
			 
					
					/*cover.removeChild(coverVideo);
					coverVideo = null;*/
				 
				frame = 0;
		}
		
		private function removeEnterFrame(reset:Boolean = false):void 
		{
			 
				removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
				//if (timer) {
					//timer.stop();
				//}
				//if (reset) {
					//timer.reset();
					//
					//timer.removeEventListener(TimerEvent.TIMER, onTimerHandler);
					//timer = null;
				//}
			 
		}
		
		private function addEnterFrame( ):void {
			 
				//if (timer == null) {
					//timer = new Timer(keyFrame,0);
					//timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
				    //timer.start();
				//}
				//
				//if (!timer.running) {
					//timer.start();
				//}
				
				addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			 
		}
		
		private function onTimerHandler(e:TimerEvent):void 
		{
			frame++;
			trace(frame);
			Debug.log("frame:"+frame+" coverVideoIndex:" + cover.getChildIndex(coverVideo)+" x:"+coverVideo.x+" y:"+coverVideo.y+" visible:"+coverVideo.visible+" alpha:"+coverVideo.alpha+" cover.visible:"+cover.visible);

			if(index==2){
				var scale:Number = Math.min(stage.stageWidth / 540, (stage.stageHeight - 63) / 303);
				var flvWidth:Number = 540 * scale;
				var flvHeight:Number = 303 * scale;
				
				if(coverVideo){
					coverVideo.width = flvWidth;
					coverVideo.height = flvHeight;
					coverVideo.gotoAndStop(frame);
					
					Debug.log("update cover video:"+frame+"coverVideo currentFrame:"+coverVideo.currentFrame);
				}
			 
				
				for (var i:int = 0; i < trackingData.length; i++) {
					
					var _data:Array = trackingData[i];
					for (var j = 0; j < _data.length; j++ ) {
						if (_data[j].frame==frame) {
							//cs[i].visible=true;
							if (i > 1) {
								cs[i].x = _data[j].x* flvWidth/1280;
								cs[i].y = (_data[j].y+60) * flvWidth / 1280;
							}else {
								cs[i].x = _data[j].x* flvWidth/1280;
								cs[i].y = _data[j].y * flvWidth / 1280;
							}
							
							continue;
						}
					}
					
				}
				
				 if(ImageContainer.sourceBitmap){
				
					drawPlane(cover.graphics, ImageContainer.sourceBitmap, 
																		new Point(cs[0].x, cs[0].y),
																		new Point(cs[1].x, cs[1].y),
																		new Point(cs[2].x, cs[2].y),
																		new Point(cs[3].x, cs[3].y)
					);
				} 
			}
		}
		
		
		
		 
		private function onClickPlayHandler(e:MouseEvent):void 
		{
			
			if (playBtn.currentFrame == 3) {
				/*ExternalInterface.call("window.location.reload");
				return;*/
				flv.replay();
				playBtn.gotoAndStop(2);
				 if (index ==2 ) {
					addEnterFrame();
				} 
				return;
			}
			if (playBtn.currentFrame == 2) {
				flv.pause();
				  if (index ==2 ) {
					removeEnterFrame();
				} 
				playBtn.gotoAndStop(1);
			}else{
				//flv.play();
				flv.pause();
				playBtn.gotoAndStop(2);
				 if (index ==2 ) {
					addEnterFrame();
				} 
			}
		}
		
		private function onResizeHandler(e:Event):void 
		{
			resize();
		}
		
		public function resize():void 
		{
			 
			bar["loading"].width = flv.loadPencent * stage.stageWidth;
			bar['progress'].width =  playprogress * (stage.stageWidth-bar['progressBtn'].width/2);
			bar['progressBtn'].x = playprogress * (stage.stageWidth - bar['progressBtn'].width);
			
			
			var scale:Number = Math.min(stage.stageWidth / 540, (stage.stageHeight - 63) / 303);
			var flvWidth:Number = 540 * scale;
			var flvHeight:Number = 303 * scale;
			 
			if(shadow){
				 shadow.width = flvWidth;
				 shadow.height = flvHeight;
			}
			 fullscreenBtn.x = stage.stageWidth - fullscreenBtn.width - 10;
			 voiceSlider.x = fullscreenBtn.x - voiceSlider.width - 15;
			 bar['base'].width = stage.stageWidth;
			 bar["loading"].width = loadingPecent * stage.stageWidth;
			 voiceIcon.x = fullscreenBtn.x - voiceIcon.width - voiceSlider.width - 20;
			 
			 switch(index) {
				 
				 case 3:
					 if(cs.length){
						for (var i:int = 0; i < 4;i++){
							cs[i].x = [129,317,-53,225][i]*flvWidth/1280;
							cs[i].y = [286,286,531,533][i]*flvWidth/1280;
						}
					
						 if(ImageContainer.sourceBitmap){
					
								drawPlane(cover.graphics, ImageContainer.sourceBitmap, 
																					new Point(cs[0].x, cs[0].y),
																					new Point(cs[1].x, cs[1].y),
																					new Point(cs[2].x, cs[2].y),
																					new Point(cs[3].x, cs[3].y)
								);
						 } 
					 }
					 break;
			 }
			 
			 
		}
		
		public function showImage(index:int):void 
		{
			switch(index) {
				case 3:
					 
					if (pointContainer == null) {
						pointContainer = new Sprite();
						cover.addChild(pointContainer);
						
					//	trace("trackingData.length:", trackingData.length);
						
						var scale:Number = Math.min(stage.stageWidth / 540, (stage.stageHeight - 63) / 303);
						var flvWidth:Number = 540 * scale;
						var flvHeight:Number = 303 * scale;
			
						for (var i:int = 0; i < 4;i++){
							c = new C();
							cs[i] = c;
							
							c['id'].text = (i + 1).toString();
							c.x = [129,317,-53,225][i]*flvWidth/1280;
							c.y = [286,286,531,533][i]*flvWidth/1280;
							 c.visible = false;
							pointContainer.addChild(c);
							
					 
						}
						pointContainer.mouseChildren = pointContainer.mouseEnabled = false;
						
						 if(ImageContainer.sourceBitmap){
				
							drawPlane(cover.graphics, ImageContainer.sourceBitmap, 
																				new Point(cs[0].x, cs[0].y),
																				new Point(cs[1].x, cs[1].y),
																				new Point(cs[2].x, cs[2].y),
																				new Point(cs[3].x, cs[3].y)
							);
						} 
				
					}
					break;
			}
		}
		
		private function onClickHandler(e:MouseEvent):void 
		{
			stage.displayState =( stage.displayState==StageDisplayState.NORMAL)?StageDisplayState.FULL_SCREEN:StageDisplayState.NORMAL;
		}
	}
}