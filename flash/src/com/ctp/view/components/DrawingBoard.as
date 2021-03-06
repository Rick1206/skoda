package com.ctp.view.components {
	import com.adobe.images.JPGEncoder;
	import com.ctp.model.AppData;
	import com.ctp.model.constant.BrushType;
	import com.ctp.model.constant.ObjectType;
	import com.ctp.view.components.drawingboard.ConfirmBox;
	import com.ctp.view.components.drawingboard.paint.BrushBoard;
	import com.ctp.view.components.drawingboard.PopupWindow;
	import com.ctp.view.components.drawingboard.resizing.ImageResizing;
	import com.ctp.view.components.drawingboard.resizing.ObjectResizing;
	import com.ctp.view.components.drawingboard.resizing.ShapeResizing;
	import com.ctp.view.components.drawingboard.resizing.TextResizing;
	import com.ctp.view.components.drawingboard.ToolBar;
	import com.ctp.view.components.drawingboard.VersionUI;
	import com.ctp.view.events.BrushEvent;
	import com.ctp.view.events.ClipartEvent;
	import com.ctp.view.events.FontTypeEvent;
	import com.ctp.view.events.ManagaEvent;
	import com.ctp.view.events.ObjectResizingEvent;
	import com.ctp.view.events.ShapeEvent;
	import com.ctp.view.events.UploadPhotoEvent;
	import com.dynamicflash.util.Base64;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.pyco.external.JSBridge;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class DrawingBoard extends Sprite {
		
		public var toolBarMovie: ToolBar = new ToolBar();
		public var boardMovie: Sprite = new Sprite();
		public var contentMovie: Sprite = new Sprite();
		public var brushMovie: BrushBoard = new BrushBoard();
		public var confirmMovie: ConfirmBox = new ConfirmBox();
		public var versionMovie: VersionUI = new VersionUI();
		public var popupMovie: PopupWindow = new PopupWindow();
		
		private var selectedObject: ObjectResizing;
		
		public function DrawingBoard() {
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			versionMovie.versionText.text = "v 1.2";
			
			toolBarMovie.addEventListener(ClipartEvent.ADD_IMAGE, addClipartImageHandler);
			toolBarMovie.addEventListener(ClipartEvent.ADD_IMAGE_AT_CENTER, addClipartImageHandler);
			
			toolBarMovie.addEventListener(UploadPhotoEvent.COMPLETE, uploadPhotoCompleteHandler);
			toolBarMovie.addEventListener(BrushEvent.ENABLE, brushEnableHandler);
			toolBarMovie.addEventListener(BrushEvent.DISABLE, brushEnableHandler);
			toolBarMovie.addEventListener(FontTypeEvent.CHANGE, fontTypeChangeHandler);
			toolBarMovie.addEventListener(FontTypeEvent.ADD_TEXT, addTextHandler);
			toolBarMovie.addEventListener(ToggleButtonBase.TOGGLE_BUTTON_CLICK, toggleButtonClickHandler);
			
			toolBarMovie.addEventListener(ShapeEvent.ADD_SHAPE, addShapeHandler);
			toolBarMovie.addEventListener(ShapeEvent.ADD_SHAPE_AT_CENTER, addShapeHandler);
			toolBarMovie.addEventListener(ShapeEvent.CHANGE_COLOR, changeColorShapeHandler);
			
			toolBarMovie.addEventListener(ManagaEvent.SEND_TO_BACK, manageHandler);
			toolBarMovie.addEventListener(ManagaEvent.BRING_TO_FRONT, manageHandler);
			toolBarMovie.addEventListener(ManagaEvent.CLEAR_ALL, manageHandler);
			
			confirmMovie.yesButton.addEventListener(MouseEvent.CLICK, yesButtonClickHandler);
			
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			}
			
			JSBridge.addCallback("getImage", getImage);
			JSBridge.addCallback("showStudentPopup", showStudentPopup);
			
			//showStudentPopup("INITIALIZING: Adobe Flex Compiler SHell (fcsh)");
		}
		
		private function changeColorShapeHandler(e:ShapeEvent):void {
			if (selectedObject && selectedObject.type == ObjectType.SHAPE) {
				selectedObject.color = toolBarMovie.shapesMenuMovie.colorSliderMovie.color;
			}
		}
		
		private function addShapeHandler(e:ShapeEvent):void {
			var shapeResizing: ShapeResizing = new ShapeResizing();
			shapeResizing.setShape(toolBarMovie.getShape());
			if (e.type == ShapeEvent.ADD_SHAPE_AT_CENTER) {
				shapeResizing.x = ObjectResizing.MAX_WIDTH / 2;
				shapeResizing.y = ObjectResizing.MAX_HEIGHT / 2;
			} else {
				shapeResizing.x = stage.mouseX;
				shapeResizing.y = stage.mouseY;
			}
			initObjectResizing(shapeResizing);
			selectedObject = shapeResizing;
		}
		
		private function toggleButtonClickHandler(e:Event):void {
			stageClickHandler(null);
		}
		
		private function manageHandler(e:ManagaEvent):void {
			var selectedObjectIndex: int;
			if (selectedObject) {
				selectedObjectIndex = contentMovie.getChildIndex(selectedObject);
			}
			switch (e.type) {
				case ManagaEvent.SEND_TO_BACK:
					selectedObjectIndex --;
					if (selectedObjectIndex >= 0 && selectedObject) {
						contentMovie.setChildIndex(selectedObject, selectedObjectIndex);
					}
					break;
				case ManagaEvent.BRING_TO_FRONT:
					selectedObjectIndex ++;
					if (selectedObjectIndex <= contentMovie.numChildren - 1 && selectedObject) {
						contentMovie.setChildIndex(selectedObject, selectedObjectIndex);
					}
					break;
				case ManagaEvent.CLEAR_ALL:
					confirmMovie.show(ManagaEvent.CLEAR_ALL);
					break;
			}
		}
		
		public function showStudentPopup(html: String):void {
			popupMovie.show(html, this);
		}
		
		private function addedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			init();
		}
		
		private function init(): void {
			AppData.parameters = stage.loaderInfo.parameters;
			//AppData.parameters.exportedImage = "images/Sunset.jpg";
			if (AppData.parameters.exportedImage) {
				addImageByUrl(AppData.parameters.exportedImage, ObjectType.IMAGE);
			}
			
			brushMovie.toolBarMovie = toolBarMovie;
			
			addChild(boardMovie);
			boardMovie.addChild(contentMovie);
			contentMovie.addChild(brushMovie);
			
			toolBarMovie.y = 5;
			addChild(toolBarMovie);
			addChild(confirmMovie);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			confirmMovie.x = ObjectResizing.MAX_WIDTH / 2;
			confirmMovie.y = ObjectResizing.MAX_HEIGHT / 2;
			versionMovie.x = stage.stageWidth;
			versionMovie.y = stage.stageHeight;
			
			if (AppData.parameters.debug != "false") {
				addChild(versionMovie);
			}
			
			stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
		}
		
		private function addTextHandler(e:FontTypeEvent):void {
			if (toolBarMovie.buttonGroupMovie.typeMovie.toggled == false) {
				return;
			}
			if (selectedObject && selectedObject.type == ObjectType.TEXT) {
				return;
			}
			var bounds: Rectangle = toolBarMovie.getTextBounds();
			var textResizing: TextResizing = new TextResizing();
			textResizing.type = ObjectType.TEXT;
			textResizing.x = bounds.x + bounds.width / 2;
			textResizing.y = bounds.y + bounds.height / 2;
			textResizing.setWidth(bounds.width);
			textResizing.setHeight(bounds.height);
			textResizing.renderTransformTool();
			textResizing.setTextFormat(toolBarMovie.fontTypeData);
			initObjectResizing(textResizing);
			textResizing.dispatchEvent(new ObjectResizingEvent(ObjectResizingEvent.CLICK));
		}
		
		private function fontTypeChangeHandler(e:FontTypeEvent):void {
			if (selectedObject) {
				selectedObject.setTextFormat(toolBarMovie.fontTypeData);
			}
		}
		
		private function brushEnableHandler(e:BrushEvent):void {
			brushMovie.setEnabled(e.type == BrushEvent.ENABLE, toolBarMovie.brushData);
			if (e.type == BrushEvent.ENABLE) {
				if (brushMovie.isEmpty) {
					var childIndex: int = contentMovie.getChildIndex(brushMovie);
					contentMovie.swapChildrenAt(childIndex, contentMovie.numChildren - 1);
				}
				stageClickHandler(null);
			}
		}
		
		public function getImage():String {
			selectedObject = null;
			stageClickHandler(null);
			var bmd: BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0xFFFFFF);
			bmd.draw(boardMovie);
			for (var i:int = 0; i < bmd.width; i++) {
				for (var j:int = 0; j < bmd.height; j++) {
					if (bmd.getPixel(i,j) != 0xFFFFFF) {
						var encoder: JPGEncoder = new JPGEncoder(80);
						return Base64.encodeByteArray(encoder.encode(bmd));
					}
				}
			}
			return "";
		}
		
		private function uploadPhotoCompleteHandler(e:UploadPhotoEvent):void {
			var imageResizing: ImageResizing = new ImageResizing();
			imageResizing.type = ObjectType.IMAGE;
			imageResizing.defaultWidth = 200;
			imageResizing.setImage(toolBarMovie.getUploadedPhoto());
			imageResizing.x = ObjectResizing.MAX_WIDTH / 2;
			imageResizing.y = ObjectResizing.MAX_HEIGHT / 2;
			selectedObject = imageResizing;
			initObjectResizing(imageResizing);
		}
		
		private function resetSelectStates(): void {
			var i:int;
			var object: ObjectResizing;
			for (i = 0; i < contentMovie.numChildren; i++) {
				object = contentMovie.getChildAt(i) as ObjectResizing;
				if (object) {
					object.showTool(false);
				}
			}
		}
		
		private function stageClickHandler(e:MouseEvent):void {
			if (confirmMovie.visible || brushMovie.painEnabled) {
				return;
			}
			if (toolBarMovie.shapesMenuOpening && selectedObject && selectedObject.type == ObjectType.SHAPE) {
				return;
			}
			if (e == null || toolBarMovie.bgMovie.hitTestPoint(stage.mouseX, stage.mouseY)) {
				resetSelectStates();
				if (selectedObject) {
					if (selectedObject.type == ObjectType.TEXT) {
						if (toolBarMovie.typeToolOpening) {
							selectedObject.showTool();
							return;
						} else {
							if (toolBarMovie.typeToolSelected) {
								selectedObject.showTool();
								return;
							}
						}
					} else if (selectedObject.type == ObjectType.SHAPE) {
						if (toolBarMovie.manageToolSelected) {
							selectedObject.showTool();
							return;
						}
					}
				} 
				selectedObject = null;
				return;
			}
			var arr: Array = ["contentMovie", "inputText", "closeButton", "deleteButton"];
			if (e && selectedObject && arr.indexOf(e.target.name) == -1) {
				resetSelectStates();
				selectedObject = null;
			}
		}
		
		private function yesButtonClickHandler(e:MouseEvent):void {
			if (selectedObject && contentMovie.contains(selectedObject)) {
				contentMovie.removeChild(selectedObject);
				selectedObject = null;
			}
			if (confirmMovie.messageMovie.totalFrames == confirmMovie.messageMovie.currentFrame) {
				while (contentMovie.numChildren) {
					contentMovie.removeChildAt(0);
				}
				contentMovie.addChild(brushMovie);
				brushMovie.clear();
			}
		}
		
		private function addClipartImageHandler(e:ClipartEvent):void {
			addImageByUrl(toolBarMovie.getClipartImageUrl(), ObjectType.CLIPART, e.type == ClipartEvent.ADD_IMAGE_AT_CENTER);
		}
		
		private function addImageByUrl(imageUrl: String, type: String, isCenter: Boolean = true): void {
			var imageResizing: ImageResizing = new ImageResizing();
			imageResizing.type = type;
			if (type == ObjectType.CLIPART) {
				if (isCenter) {
					imageResizing.x = stage.stageWidth / 2;
					imageResizing.y = stage.stageHeight / 2;
				} else {
					imageResizing.x = stage.mouseX;
					imageResizing.y = stage.mouseY;
				}
			} else {
				imageResizing.defaultWidth = stage.stageWidth;
				imageResizing.x = stage.stageWidth / 2;
				imageResizing.y = stage.stageHeight / 2;
			}
			imageResizing.load(imageUrl);
			initObjectResizing(imageResizing);
			selectedObject = imageResizing;
		}
		
		private function initObjectResizing(objResizing: ObjectResizing): void {
			//stageClickHandler(null);
			objResizing.addEventListener(ObjectResizingEvent.CLICK, objectResizingClickHandler, false, 0, true);
			objResizing.addEventListener(ObjectResizingEvent.DELETE, objectResizingDeleteHandler, false, 0, true);
			//objResizing.addEventListener(MouseEvent.RIGHT_CLICK, objectResizingRightClickHandler, false, 0, true);
			contentMovie.addChild(objResizing);
			resetSelectStates();
			objResizing.showTool();
		}
		
		//private function objectResizingRightClickHandler(e:MouseEvent):void {
			//e.stopImmediatePropagation();
			//selectedObject = e.currentTarget as ObjectResizing;
			//menuMovie.show();
			//objectResizingClickHandler(e);
			//toolBarMovie.closeSubTool();
		//}
		
		private function objectResizingDeleteHandler(e:ObjectResizingEvent):void {
			selectedObject = e.currentTarget as ObjectResizing;
			confirmMovie.show(selectedObject.type);
		}
		
		private function objectResizingClickHandler(e:Event):void {
			if (brushMovie.painEnabled) {
				return;
			}
			selectedObject = e.currentTarget as ObjectResizing;
			for (var i:int = 0; i < contentMovie.numChildren; i++) {
				var object: ObjectResizing = contentMovie.getChildAt(i) as ObjectResizing;
				if (object) {
					object.showTool(object == selectedObject);
				}
			}
			brushMovie.setEnabled(false);
			if ((selectedObject && selectedObject.type != ObjectType.TEXT) || toolBarMovie.buttonGroupMovie.typeMovie.toggled == false) {
				toolBarMovie.buttonGroupMovie.reset();
			}
		}
		
	}

}