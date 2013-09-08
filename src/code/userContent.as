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
	
	public class userContent extends MovieClip
	{
		
		private var bm:Bitmap;
		private var _height:Number;
		private var _width:Number;
		private var newRatio:Number;
		private var _bmpdata:BitmapData
		private var _matrix:Matrix;
		
		private var _scaledBmp:Bitmap;
		
		public function userContent()
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
			
			btnInspire.addEventListener(MouseEvent.CLICK, onUploadHeadPicHandler);
			
			scrollbarMovie.init(contentMovie, maskMovie, "vertical", true, false, false, 12);
			
			contentMovie.q1.initData("q1");
			
			contentMovie.q2.initData("q2");
			
			contentMovie.q3.initData("q3");
			
			contentMovie.q4.initData("q4");
			
			contentMovie.q5.initData("q5");
		
		}
		
		private function onUploadHeadPicHandler(e:MouseEvent):void
		{
			//UploadPhotoPopup.instance.init();
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
				TweenMax.to(_scaledBmp, .2, {autoAlpha: 1});
				TweenMax.to(UploadPhotoPopup.instance, .2, {autoAlpha: 0});
			}
		
		}
	}

}
