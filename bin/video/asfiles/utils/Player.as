package asfiles.utils

{
	
	import fl.video.MetadataEvent;
	import fl.video.VideoEvent;
	import fl.video.VideoState;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import asfiles.events.MetaEvent;
	import asfiles.events.PlayerEvent;
	import asfiles.events.SliderEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import code.GlobalVars;
	public class Player extends Sprite
	
	{
		public var loading:MovieClip;
		public var loadPencent:int;
		public var isStartPlaying:Boolean;
		
		private var __nConnection:NetConnection;
		private var __nStream:NetStream;
		private var __vVideo:Video;
		private var __sVideo:String;
		private var __nDuration:Number;
		private var __tTimer:Timer;
		private var __bPaused:Boolean;
		
		private var __nWidth:Number;
		private var __nHeight:Number;
		
		private var __bufferTime:Number;
		
		private var loaded_interval:Number;
		private var lastime:Number;
		private var isOver:Boolean;
		
		private var __curTime:Number;
		
		public function Player()
		
		{
			
			__tTimer = new Timer(300, 0);
			
			__tTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			
			__nConnection = new NetConnection();
			
			__nConnection.connect(null);
			
			prepareStream();
			
			
		}
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			
			Debug.log("event.info.code:" + event.info.code);
			switch (event.info.code.toString())
			{
				case "NetConnection.Connect.Success":
					
					prepareStream();
					addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
					
					break;
				case "NetStream.Play.StreamNotFound": 
					trace("Unable to locate video: " + __sVideo);
					break;
				case "NetStream.Play.Start": 
					loading.visible = true;
					if (!isStartPlaying)
					{
						isStartPlaying = true;
						dispatchEvent(new VideoEvent(VideoEvent.READY));
					}
					addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
					dispatchEvent(new VideoEvent(VideoEvent.REWIND));
					break;
				case "NetStream.Buffer.Empty": 
					removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
					if (!isOver)
					{
						loading.visible = true;
						dispatchEvent(new Event("waiting"));
					}
					else
					{
						loading.visible = false;
					}
					break;
				case "NetStream.Buffer.Flush": 
					loading.visible = false;
					break;
				case "NetStream.Buffer.Full":
					addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
					loading.visible = false;
					dispatchEvent(new Event("ok"));
					break;
				case "NetStream.Seek.InvalidTime": 
				case "NetStream.Seek.Failed": 
					loading.visible = true;
					seek(__nStream.time);
					break;
				case "NetStream.Seek.Notify": 
					loading.visible = false;
					break;
				case "NetStream.Play.Stop": 
					isStartPlaying = false;
					loading.visible = false;
					isOver = true;
					removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
					dispatchEvent(new VideoEvent(VideoEvent.COMPLETE));
					break;
				case "NetStream.Seek.Notify": 
					break;
			}
		
		}
		
		private function onEnterFrameHandler(e:Event):void
		{
			if (__nStream != null) {
				//trace(__nStream.time);
				GlobalVars.setTime(__nStream.time);
			}
		}
		
		public function setVoice(value:Number):void
		{
			var st:SoundTransform = new SoundTransform();
			st.volume = value;
			__nStream.soundTransform = st;
		}
		
		private function prepareStream():void
		
		{
			
			__nStream = new NetStream(__nConnection);
			
			__nStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			
			__nStream.client = this;
			
			__nStream.bufferTime = 3;
			
			__vVideo = new Video();
			
			__vVideo.smoothing = true;
			
			__vVideo.attachNetStream(__nStream);
			
			loaded_interval = setInterval(checkBytesLoaded, 500, __nStream);
		
		}
		
		public function onBWDone(... rest):void
		{
			
			var p_bw:Number;
			
			if (rest.length > 0)
				p_bw = rest[0];
			
			trace("bandwidth = " + p_bw + " Kbps.");
		
		}
		
		public function onPlayStatus(infoObject:Object):void
		{
			
			if (infoObject.info == "NetStream.Play.Complete")
			{
				dispatchEvent(new Event(Event.COMPLETE));
				loading.visible = false;
			}
		
		}
		
		public function onXMPData(... rest):void
		{
		
		}
		
		public function onCuePoint(infoObject:Object)
		{
			trace("onCuePoint:");
			for (var propName:String in infoObject)
			{
				if (propName != "parameters")
				{
					trace(propName + " = " + infoObject[propName]);
				}
				else
				{
					trace("parameters =");
					if (infoObject.parameters != undefined)
					{
						for (var paramName:String in infoObject.parameters)
						{
							trace(" " + paramName + ": " + infoObject.parameters[paramName]);
						}
					}
					else
					{
						trace("undefined");
					}
				}
			}
			var me:MetadataEvent = new MetadataEvent(MetadataEvent.CUE_POINT);
			me.info = infoObject;
			dispatchEvent(me);
			trace("---------");
		}
		
		public function metaDataHandler(infoObject:Object):void
		{
		}
		
		public function onMetaData(pMeta):void
		
		{
			
			__nDuration = pMeta.duration;
			
			trace("__nDuration:", __nDuration);
			
			__nWidth = pMeta.width;
			
			__nHeight = pMeta.height;
			
			dispatchEvent(new MetaEvent(MetaEvent.ON_META, pMeta));
			
			addChild(__vVideo);
		
		}
		
		private function checkBytesLoaded(my_ns:NetStream)
		{
			loadPencent = my_ns.bytesLoaded / my_ns.bytesTotal;
			dispatchEvent(new PlayerEvent(PlayerEvent.ON_LOAD_PROGRESS, 0, 0));
			
			if (loadPencent >= 1)
			{
				clearInterval(loaded_interval);
			}
		}
		
		private function securityErrorHandler(pError:SecurityErrorEvent):void
		
		{
			
			dispatchEvent(new MetaEvent(MetaEvent.ON_META, pError));
		
		}
		
		public function replay()
		{
			play(__sVideo);
		}
		
		public function play(pFile:String):void
		
		{
			
			__nStream.play(__sVideo = pFile);
			
			__tTimer.start();
		
			//addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		public function pause():void
		
		{
			
			//removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			
			__nStream.togglePause();
			
			__bPaused = !__bPaused;
		
		}
		
		private function timerHandler(pEvt:TimerEvent):void
		
		{
			if (__nStream.time != lastime)
			{
				lastime = __nStream.time;
				dispatchEvent(new PlayerEvent(PlayerEvent.ON_PROGRESS, __nStream.time, __nStream.time / __nDuration));
			}
			if (__nStream.time >= __nDuration)
				__tTimer.stop();
		
		}
		
		public function onMouseIsDown(pEvt):void
		
		{
			
			__nStream.pause();
			
			__tTimer.stop();
		
		}
		
		public function setSize(pWidth:Number, pHeight:Number):void
		
		{
			
			__vVideo.width = pWidth;
			
			__vVideo.height = pHeight;
		
		}
		
		public function seek(pTiming:Number):void
		
		{
			
			__nStream.seek(pTiming);
		
		}
		
		public function onMovin(pEvt:SliderEvent):void
		
		{
			
			__nStream.seek(pEvt.value * __nDuration);
		
		}
		
		public function onMouseIsUp(pEvt:Event):void
		
		{
			
			if (!__bPaused)
				__nStream.resume();
			
			__tTimer.start();
		
		}
		
		override public function get width():Number
		
		{
			
			return __nWidth;
		
		}
		
		override public function get height():Number
		
		{
			
			return __nHeight;
		
		}
		
		public function get bufferTime():Number
		{
			return __bufferTime;
		}
		
		public function set bufferTime(value:Number):void
		{
			__bufferTime = value;
			__nStream.bufferTime = value;
		
		}
		
		public function get curTime():Number 
		{
			return __curTime;
		}
		
		public function set curTime(value:Number):void 
		{
			__curTime = value;
		}
	
	}

}