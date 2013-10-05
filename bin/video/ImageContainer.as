package 
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author etall
	 */
	public class ImageContainer extends Sprite
	{
		public var loader:Loader;
		private var _src:String;
		public var container:Sprite;
		private var _nickname:String;
		private var _containerWidth:int=103;
		private var _containerHeight:int=103;
		private var nickContainer:Sprite;
		public var msk:Sprite;
		public var index:int=1;
		static public var sourceBitmap:BitmapData;
		public function ImageContainer() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			nickContainer = new Sprite();
			addChild(nickContainer);
			
			container.mask = msk;
		}
		
		public function get src():String 
		{
			return _src;
		}
		
		public function set src(value:String):void 
		{
			_src = value;
			
			msk.width = containerWidth;
			msk.height = containerHeight;
			
			if (loader == null) {
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadCompleteHandler);
				loader.load(new URLRequest(value),new LoaderContext(true));
			}
		}
		
		public function get nickname():String 
		{
			return _nickname;
		}
		
		public function set nickname(value:String):void 
		{
			_nickname = value;
			
			var tf:TextField = new TextField();
			
			
			var fmt:TextFormat = new TextFormat("黑体");
			switch(index) {
				case 0:
					fmt.size = 20;
					break;
				case 1:
					fmt.size = 30;
					break;
				
			}
			
			fmt.color = 0xffffff;
			//fmt.bold = true;
			//tf.multiline = true;
			//tf.wordWrap = true;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.defaultTextFormat = fmt;
			var ds:DropShadowFilter = new DropShadowFilter(0, 0, 0, .5);
			tf.filters = [ds];
			
			/*tf.border=true;
			tf.borderColor = 0xff0000;*/
			tf.text = value;
			tf.width = Math.min(tf.textWidth, containerWidth+5);
			//tf.width = tf.textWidth;
			
			
			var bmd:BitmapData = new BitmapData(tf.width, tf.height, true,0xff);
			bmd.draw(tf);
			var bm:Bitmap = new Bitmap(bmd);
			bm.smoothing = true;
			
			nickContainer.addChild(bm);
			
			nickContainer.x = (containerWidth - nickContainer.width) / 2;
			switch(index) {
				case 0:
					nickContainer.y = containerHeight ;
					break;
				case 1:
					nickContainer.y = containerHeight + 7;
					break;
				case 2:
					nickContainer.y = containerHeight + 10;
					break;
				case 3:
					nickContainer.y = containerHeight + 13;
					break;
				
			}
			
			
			
			trace("bm.y:",bm.y);
			

			trace(value);
			
		}
		
		public function get containerWidth():int 
		{
			return _containerWidth;
		}
		
		public function set containerWidth(value:int):void 
		{
			_containerWidth = value;
		}
		
		public function get containerHeight():int 
		{
			return _containerHeight;
		}
		
		public function set containerHeight(value:int):void 
		{
			_containerHeight = value;
		}
		
		private function onLoadCompleteHandler(e:Event):void 
		{
			var bm:Bitmap = e.target.content as Bitmap;
			bm.smoothing = true;
			bm.scaleX = bm.scaleY = Math.max(containerWidth/ bm.width, containerHeight/ bm.height);
			container.addChild(bm);
			 
			var bmd:BitmapData;
			switch(index) {
				case 2:
					bmd= new BitmapData(this.width, this.height+15, true, 0xff0000);
					
					break;
				case 3:
					bmd= new BitmapData(this.width, this.height, true, 0xff0000);
					break;
				default:
					bmd= new BitmapData(this.width, this.height, true, 0xff0000);
					break;
			}
			bmd.draw(this);
			sourceBitmap = bmd;
			//stage.addChild(new Bitmap(sourceBitmap.clone()));
			 
		}
		
		
	}
	
}