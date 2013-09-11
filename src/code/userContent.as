﻿package code
{
	
	import com.ctp.view.components.drawingboard.UploadPhotoPopup;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.ctp.view.events.UploadPhotoEvent;
	import flash.geom.Matrix;
	import code.tool.RollTool;
	import com.greensock.TweenMax;
	
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import com.adobe.images.JPGEncoder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import com.dynamicflash.util.Base64;
	import com.adobe.serialization.json.JSON;
	import com.ctp.model.AppData;
	
	public class userContent extends MovieClip
	{
		
		private var bm:Bitmap;
		private var _height:Number;
		private var _width:Number;
		private var newRatio:Number;
		private var _bmpdata:BitmapData
		private var _matrix:Matrix;
		
		private var _scaledBmp:Bitmap;
		
		private var tracker:AnalyticsTracker;
		
		private var _userName:String;
		
		private var _userHead:String;
		
		private var _urlreq:URLRequest;
		private var _urlvar:URLVariables;
		private var _urlloa:URLLoader;
		
		public function userContent()
		{
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function getUserInfo():void
		{
			
			_urlvar = new URLVariables();
			_urlreq = new URLRequest();
			_urlloa = new URLLoader();
			
			var strBackendUrl:String = AppData.parameters.backendUrl ? AppData.parameters.backendUrl : "./function_all/index.php";
			
			//var strBackendUrl:String = "http://localhost/skoda/function_all/index.php";
			
			trace(strBackendUrl);
			_urlvar.Fun_type = "User_Profile";
			
			_urlloa.addEventListener(Event.COMPLETE, onCompInfoHandle);
			_urlreq.data = _urlvar;
			_urlreq.url = strBackendUrl;
			_urlreq.method = "POST";
			//_urlloa.dataFormat = URLLoaderDataFormat.BINARY;
			_urlloa.load(_urlreq);
		}
		
		private function onCompInfoHandle(e:Event):void
		{
			//trace(e.content);
			trace(e.target.data);
			
			var myData:Object = JSON.decode(e.target.data);
			if (myData.state == "1")
			{
				this.userName = myData.profile.username;
				loadPic(myData.profile.headpic);
				
				contentMovie.q1.ans = myData.profile.profile_q1;
				GlobalVars.setQ1(myData.profile.profile_q1);
				contentMovie.q2.ans = myData.profile.profile_q2;
				GlobalVars.setQ2(myData.profile.profile_q2);
				contentMovie.q3.ans = myData.profile.profile_q3;
				GlobalVars.setQ3(myData.profile.profile_q3);
				contentMovie.q4.ans = myData.profile.profile_q4;
				GlobalVars.setQ4(myData.profile.profile_q4);
				contentMovie.q5.ans = myData.profile.profile_q5;
				GlobalVars.setQ5(myData.profile.profile_q5);
			}
		
		}
		
		private function loadPic(str:String)
		{
			var loader:Loader = new Loader;
			loader.load(new URLRequest(str));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadPic);
		}
		
		private function onLoadPic(e:Event):void
		{
			e.target.content.removeEventListener(Event.COMPLETE, onLoadPic);
			
			var pic:Bitmap = e.target.content as Bitmap;
			pic.smoothing = true;
			var bmd:BitmapData = new BitmapData(145, 145);
			bmd.draw(pic);
			
			var bm:Bitmap = new Bitmap(bmd);
			
			bm.x = -bm.width / 2;
			bm.y = -bm.height / 2;
			
			headPic.picFrame.addChild(bm);
			
			TweenMax.to(headPic.defaultpic, .2, {autoAlpha: 0});
			TweenMax.to(headPic.picFrame, .2, {autoAlpha: 1});
		
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			tracker = new GATracker(this, "UA-34374356-3", "AS3", false);
			
			btnInspire.addEventListener(MouseEvent.CLICK, onUploadHeadPicHandler);
			
			scrollbarMovie.init(contentMovie, maskMovie, "vertical", true, false, false, 12);
			
			contentMovie.q1.initData("q1");
			contentMovie.q2.initData("q2");
			contentMovie.q3.initData("q3");
			contentMovie.q4.initData("q4");
			contentMovie.q5.initData("q5");
			
			txtUserName.addEventListener(MouseEvent.ROLL_OUT, onRollHandler);
			txtUserName.addEventListener(MouseEvent.ROLL_OVER, onRollHandler);
			
			//-- test --//
			//var bmd:BitmapData = new BitmapData(145, 145, false, 0xFFFFFF);
			//var myMatrix:Matrix = new Matrix();
			//myMatrix.translate(bmd.width/2,bmd.height/2);
			//bmd.draw(headPic,myMatrix);
			
			//var bmp:Bitmap = new Bitmap(bmd);
			//addChild(bmp);
			
			getUserInfo();
		
		}
		
		private function onRollHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case "rollOut": 
					Mouse.cursor = MouseCursor.ARROW;
					break;
				case "rollOver": 
					Mouse.cursor = MouseCursor.IBEAM;
					break;
			}
		}
		
		private function onUploadHeadPicHandler(e:MouseEvent):void
		{
			
			try
			{
				tracker.trackEvent("/idea-submission", "click", "upload-image-is");
			}
			catch (error:Error)
			{
				trace(error);
			}
			
			UploadPhotoPopup.instance.type = "user";
			UploadPhotoPopup.instance.reset();
			
			UploadPhotoPopup.instance.addEventListener(UploadPhotoEvent.COMPLETE, uploadPhotoCompleteHandler);
			
			TweenMax.to(UploadPhotoPopup.instance, .2, {autoAlpha: 1});
		
		}
		
		private function uploadPhotoCompleteHandler(e:UploadPhotoEvent):void
		{
			
			if (e.ptype == "user")
			{
				bm = UploadPhotoPopup.instance.uploadedPhoto as Bitmap;
				
				_height = bm.height;
				_width = bm.width;
				
				if (_height > 2870 && _width > 2870)
				{
					if (_height < _width)
					{
						newRatio = 2870 / _width;
					}
					else if (_height > _width)
					{
						newRatio = 2870 / _height;
					}
					else
					{
						newRatio = 2870 / _width;
					}
				}
				else
				{
					newRatio = 1.0;
				}
				
				if (_bmpdata != null)
				{
					_bmpdata.dispose();
				}
				
				_bmpdata = new BitmapData(_width * newRatio, _height * newRatio);
				_matrix = new Matrix();
				
				_matrix.scale(newRatio, newRatio);
				_bmpdata.draw(bm, _matrix);
				
				_scaledBmp = new Bitmap(_bmpdata, "auto", true);
				
				_scaledBmp.scaleX = 145 * 1.5 / (_width * newRatio);
				_scaledBmp.scaleY = _scaledBmp.scaleX;
				
				_scaledBmp.alpha = 0;
				
				_scaledBmp.x = -_scaledBmp.width / 2;
				_scaledBmp.y = -_scaledBmp.height / 2;
				
				headPic.picFrame.addChild(_scaledBmp);
				
				TweenMax.to(headPic.defaultpic, .2, {autoAlpha: 0});
				
				TweenMax.to(UploadPhotoPopup.instance, .2, {autoAlpha: 0});
				TweenMax.to(headPic.picFrame, .2, {autoAlpha: 1});
				
			}
		
		}
		
		public function get userName():String
		{
			
			_userName = txtUserName.text
			return _userName;
		}
		
		public function set userName(value:String):void
		{
			_userName = value;
			txtUserName.text = _userName;
		}
		
		public function get userHead():String
		{
			_userHead = this.getImg();
			return _userHead;
		}
		
		public function set userHead(value:String):void
		{
			_userHead = value;
		}
		
		private function getImg():String
		{
			
			var bmd:BitmapData = new BitmapData(145, 145, false, 0xFFFFFF);
			var myMatrix:Matrix = new Matrix();
			myMatrix.translate(bmd.width / 2, bmd.height / 2);
			bmd.draw(headPic, myMatrix);
			
			for (var i:int = 0; i < bmd.width; i++)
			{
				for (var j:int = 0; j < bmd.height; j++)
				{
					if (bmd.getPixel(i, j) != 0xFFFFFF)
					{
						var encoder:JPGEncoder = new JPGEncoder(80);
						return Base64.encodeByteArray(encoder.encode(bmd));
					}
				}
			}
			return "";
		}
	
	}

}