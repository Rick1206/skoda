package com.ctp.view.components.drawingboard.clipart {
	import com.ctp.model.AppData;
	import com.ctp.view.components.drawingboard.ClipartUI;
	import com.ctp.view.events.ClipartEvent;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ClipartPanel extends ClipartUI {
		
		private var data: XMLList;
		private var current: int = -1;
		private var items: Array = [];
		private var isLoading: Boolean = false;
		private var isStarted: Boolean = false;
		private var isDragging: Boolean = false;
		public var dragItem: ClipartItem = new ClipartItem();
		
		public function ClipartPanel() {
			visible = false;
			alpha = 0;
			errorText.mouseEnabled = false;
			scrollbarMovie.init(contentMovie, maskMovie, "vertical", true, false, false, 12);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			//reset();
		}
		
		public function reset(): void {
			if (isStarted) {
				return;
			}
			isStarted = true;
			while (contentMovie.numChildren) {
				contentMovie.removeChildAt(0);
			}
			
			//scrollbarMovie.reInit();
			
			errorText.text = "";
			errorText.visible = true;
			items = [];
			current = -1;
			loadingMovie.play();
			loadingMovie.visible = true;
			
			loadXML();
		}
		
		private function loadXML():void {
			if (isLoading) {
				return;
			}
			isLoading = true;
			var loader: URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadXMLCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			//trace("xml :" + AppData.parameters.categoryUrl);
			loader.load(new URLRequest(AppData.parameters.categoryUrl ? AppData.parameters.categoryUrl : "xml/clipart.xml"));
		}
		
		private function loadXMLCompleteHandler(e:Event):void {
			var loader: URLLoader = e.currentTarget as URLLoader;
			var dataXML: XML = XML(loader.data);
			data = dataXML.item;
			if (data.length() > 0) {
				loadImage();
			} else {
				showError("There is no item.");
			}
		}
		
		private function showError(message: String): void {
			loadingMovie.stop();
			loadingMovie.visible = false;
			isLoading = false;
			errorText.visible = true;
			errorText.text = message;
		}
		
		private function loadImage():void {
			current++;
			var item: ClipartItem;
			if (data.length() == current) {
				var posY: int = 0;
				for (var i:int = 0; i < items.length; i++) {
					item = items[i] as ClipartItem;
					item.y = posY;
					contentMovie.addChild(item);
					posY += item.height + 15;
				}
				scrollbarMovie.reInit();
				loadingMovie.stop();
				loadingMovie.visible = false;
				errorText.visible = false;
				isLoading = false;
				return;
			}
			item = new ClipartItem();
			item.data.id = data[current].id;
			item.data.thumb = data[current].thumb;
			item.data.url = data[current].url;
			item.doubleClickEnabled = true;
			item.addEventListener(MouseEvent.MOUSE_DOWN, itemMouseDownHandler);
			item.addEventListener(MouseEvent.DOUBLE_CLICK, itemDoubleClickHandler);
			item.addEventListener(ClipartEvent.LOAD_IMAGE_COMPLETE, loadImageCompleteHandler);
			item.addEventListener(ClipartEvent.LOAD_IMAGE_ERROR, loadImageErrorHandler);
			item.load();
		}
		
		private function itemDoubleClickHandler(e:MouseEvent):void {
			dispatchEvent(new ClipartEvent(ClipartEvent.ADD_IMAGE_AT_CENTER));
		}
		
		private function itemMouseDownHandler(e:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			var target: ClipartItem = e.currentTarget as ClipartItem;
			dragItem.data = target.data;
			dragItem.x = stage.mouseX;
			dragItem.y = stage.mouseY;
			dragItem.setImage(new Bitmap(target.bitmap.bitmapData.clone(), "auto", true));
		}
		
		private function mouseMoveHandler(e:MouseEvent):void {
			var distanceX: int = Math.abs(stage.mouseX - dragItem.x);
			var distanceY: int = Math.abs(stage.mouseY - dragItem.y);
			if (distanceX >= 3 && distanceY >= 3) {
				isDragging = true;
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				dragItem.x = stage.mouseX - (dragItem.width / 2);
				dragItem.y = stage.mouseY - (dragItem.height / 2);
				addChild(dragItem);
				dragItem.startDrag();
			}
		}
		
		private function mouseLeaveHandler(e:Event):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
			
			if (this.contains(dragItem)) {
				dragItem.stopDrag();
				removeChild(dragItem);
			}
			
			if (e != null) {
				isDragging = false;
			}
		}
		
		private function mouseUpHandler(e:MouseEvent):void {
			mouseLeaveHandler(null);
			if (isDragging) {
				isDragging = false;
				dispatchEvent(new ClipartEvent(ClipartEvent.ADD_IMAGE));
			}
		}
		
		private function loadImageErrorHandler(e:ClipartEvent):void {
			loadImage();
		}
		
		private function loadImageCompleteHandler(e:ClipartEvent):void {
			items.push(e.currentTarget);
			loadImage();
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			showError("IO Error.");
		}
		
	}

}