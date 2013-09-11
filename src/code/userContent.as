package code
{
	
	import com.ctp.view.components.drawingboard.UploadPhotoPopup;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
	
	import com.dynamicflash.util.Base64;
	
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
			
			TweenMax.to(UploadPhotoPopup.instance, .2, { autoAlpha: 1 } );
			
			
			
			
		
			
			
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
				
				TweenMax.to(UploadPhotoPopup.instance, .2, { autoAlpha: 0 } );
				TweenMax.to(_scaledBmp, .2, {autoAlpha: 1});
				
				
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
		
		private function getImg():String {
			
			var bmd:BitmapData = new BitmapData(145, 145, false, 0xFFFFFF);
			var myMatrix:Matrix = new Matrix();
			myMatrix.translate(bmd.width/2,bmd.height/2);
			bmd.draw(headPic,myMatrix);
			
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
