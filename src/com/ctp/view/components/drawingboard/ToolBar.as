package com.ctp.view.components.drawingboard {
	//-- Brush Type --//
	import com.ctp.model.constant.BrushType;
	import com.ctp.model.vo.BrushInfo;
	
	import com.ctp.view.components.drawingboard.clipart.ClipartPanel;
	import com.ctp.view.components.drawingboard.paint.AirBrushTool;
	import com.ctp.view.components.drawingboard.paint.BrushTool;
	import com.ctp.view.components.drawingboard.paint.EraserTool;
	
	//import com.ctp.view.components.drawingboard.paint.PaintBucketTool;
	import com.ctp.view.components.ToggleButtonBase;
	import com.ctp.view.components.ToggleGroupBase;
	
	import com.ctp.model.vo.FontTypeInfo;
	import com.ctp.view.events.BrushEvent;
	import com.ctp.view.events.ClipartEvent;
	import com.ctp.view.events.FontTypeEvent;
	import com.ctp.view.events.ManagaEvent;
	//import com.ctp.view.events.ShapeEvent;
	import com.ctp.view.events.UploadPhotoEvent;
	import com.greensock.TweenLite;
	//call js interface
	import com.pyco.external.JSBridge;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import com.ctp.model.constant.BrushType;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class ToolBar extends ToolBarUI {
		//text 
		public var typeToolMovie: TypeTool = new TypeTool();
		
		public var brushToolMovie: BrushTool = new BrushTool();
		public var airBrushToolMovie: AirBrushTool = new AirBrushTool();
		public var eraserToolMovie:EraserTool = new EraserTool();
		
		//public var paintBucketToolMovie: PaintBucketTool = new PaintBucketTool();
		
		//public var shapesMenuMovie: ShapesMenu = new ShapesMenu();
		public var uploadPhotoMovie: UploadPhotoPopup = new UploadPhotoPopup();
		public var clipartMovie: ClipartPanel = new ClipartPanel();
		
		//public var clearToolMovie:ClearButton = new ClearButton();
		
		public var currentTool: * = null;
		
		public var fontTypeData: FontTypeInfo = new FontTypeInfo();
		
		private var _data: BrushInfo = new BrushInfo();
		public var brushData: BrushInfo;
	
		private var penTool: Dictionary = new Dictionary(true);
		
		public function ToolBar() {
			
			uploadPhotoMovie.closeButton.addEventListener(MouseEvent.CLICK, closeSubTool);
			
			uploadPhotoMovie.addEventListener(UploadPhotoEvent.COMPLETE, uploadPhotoCompleteHandler);
			
			buttonGroupMovie.addEventListener(ToggleButtonBase.TOGGLE_BUTTON_CLICK, toggleButtonClickHandler);
			
			
			typeToolMovie.addEventListener(FontTypeEvent.CHANGE, fontTypeChangeHandler);
			
			
			brushToolMovie.addEventListener(BrushEvent.CHANGE, brushChangeHandler);
			
			airBrushToolMovie.addEventListener(BrushEvent.CHANGE, airBrushChangeHandler);
			
			eraserToolMovie.addEventListener(BrushEvent.CHANGE, eraserClickHandler);
			
			
			clipartMovie.addEventListener(ClipartEvent.ADD_IMAGE, addClipartImageHandler);
			clipartMovie.addEventListener(ClipartEvent.ADD_IMAGE_AT_CENTER, addClipartImageHandler);
			
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			penTool[buttonGroupMovie.penMovie.airBushMovie] = airBrushToolMovie;
			penTool[buttonGroupMovie.penMovie.brushMovie] = brushToolMovie;
			
			//penTool[buttonGroupMovie.penMovie.paintMovie] = paintBucketToolMovie;
		}
		
		//private function changeColorShapeHandler(e:ShapeEvent):void {
			//dispatchEvent(e);
		//}
		//
		//private function addShapeHandler(e:ShapeEvent):void {
			//dispatchEvent(e);
		//}

		private function uploadPhotoCompleteHandler(e:UploadPhotoEvent):void {
			closeSubTool();
			dispatchEvent(e);
		}
		
		//public function getShape(): MovieClip {
			//return shapesMenuMovie.getShape();
		//}
		
		public function getTextBounds(): Rectangle {
			return typeToolMovie.selectedBounds;
		}
		
		public function getUploadedPhoto(): Bitmap {
			return uploadPhotoMovie.uploadedPhoto;
		}
		
		public function getClipartImageUrl(): String {
			return clipartMovie.dragItem.data.url;
		}
		
		private function addClipartImageHandler(e:ClipartEvent):void {
			dispatchEvent(e);
		}
		
		private function eraserClickHandler(e:BrushEvent):void 
		{
			brushData = eraserToolMovie.data;
			dispatchEvent(new BrushEvent(BrushEvent.ENABLE));
		}
		
		private function brushChangeHandler(e:BrushEvent):void {
			brushData = brushToolMovie.data;
			dispatchEvent(new BrushEvent(BrushEvent.ENABLE));
		}
		
		private function airBrushChangeHandler(e:BrushEvent):void {
			brushData = airBrushToolMovie.data;
			dispatchEvent(new BrushEvent(BrushEvent.ENABLE));
		}
		
		private function paintChangeHandler(e:BrushEvent):void {
			//brushData = paintBucketToolMovie.data;
			//dispatchEvent(new BrushEvent(BrushEvent.ENABLE));
		}
		
		private function fontTypeChangeHandler(e:FontTypeEvent):void {
			fontTypeData = typeToolMovie.data;
			dispatchEvent(e);
		}
		
		private function addedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			addChild(brushToolMovie);
			addChild(airBrushToolMovie);
			
			eraserToolMovie.x  = 222.85;
			eraserToolMovie.y  = 78.45;
			addChild(eraserToolMovie);
			
			//addChild(paintBucketToolMovie);
			//revise by rick
			
			typeToolMovie.x = 18.35;
			typeToolMovie.y = -65.75;
			
			addChild(typeToolMovie);
			
			uploadPhotoMovie.x = 158;
			uploadPhotoMovie.y = -122.85;
			addChild(uploadPhotoMovie);
			
			
			clipartMovie.x = -345.7;
			clipartMovie.y = 34.3;
			addChild(clipartMovie);
			//addChild(shapesMenuMovie);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
		}
		
		private function stageMouseDownHandler(e:MouseEvent):void {
			if (currentTool) {
				//trace("currentTool hitTestPoint:" + currentTool.hitTestPoint(stage.mouseX, stage.mouseY));
				if (currentTool.hitTestPoint(stage.mouseX, stage.mouseY) == false 
						/*&& bgMovie.hitTestPoint(stage.mouseX, stage.mouseY, true) == false*/) {
					closeSubTool();
				} else {
					e.stopImmediatePropagation();
				}
			}
		}
		
		public function closeSubTool(e: Event = null): void {
			if (currentTool == null) {
				return;
			}
			TweenLite.to(currentTool, 0.2, { autoAlpha: 0, overwrite: true } );
			if (currentTool == clipartMovie || currentTool == uploadPhotoMovie ) {
				buttonGroupMovie.reset();
			}
			currentTool = null;
		}
		
		public function get typeToolOpening(): Boolean {
			return currentTool == typeToolMovie;
		}
		
		public function get typeToolSelected(): Boolean {
			if (buttonGroupMovie.typeMovie.hitTestPoint(stage.mouseX, stage.mouseY) && buttonGroupMovie.typeMovie.toggled) {
				return true;
			}
			return false;
		}
		
		//public function get shapesMenuOpening(): Boolean {
			//return currentTool == shapesMenuMovie;
		//}
		
		public function get manageToolSelected(): Boolean {
			return buttonGroupMovie.toggledButton == buttonGroupMovie.manageMovie;
		}
		
		private function toggleButtonClickHandler(e:Event):void {
			var selectedTool: * ;
			if (currentTool) {
				TweenLite.to(currentTool, 0.2, { autoAlpha: 0, overwrite: true } );
			}
			var needToReturn: Boolean = false;
			switch (buttonGroupMovie.toggledButton) {
				//case buttonGroupMovie.shapeMovie:
					//selectedTool = shapesMenuMovie;
					//break;
				case buttonGroupMovie.eraserMovie:
					selectedTool = eraserToolMovie;
					break;
				case buttonGroupMovie.clearMovie:
					dispatchEvent(new ManagaEvent(ManagaEvent.CLEAR_ALL));
					break;	
				case buttonGroupMovie.typeMovie:
					//fontdata 
					selectedTool = typeToolMovie;
					typeToolMovie.data = fontTypeData;
					break;
				case buttonGroupMovie.uploadImageMovie:
					selectedTool = uploadPhotoMovie;
					uploadPhotoMovie.reset();
					break;
				case buttonGroupMovie.clipartMovie:
					selectedTool = clipartMovie;
					clipartMovie.reset();
					break;
				case buttonGroupMovie.penMovie:
					if (buttonGroupMovie.penMovie.stageClicked == false) {
						selectedTool = penTool[buttonGroupMovie.penMovie.selectedButton]
					}
					if (buttonGroupMovie.penMovie.isShowing) { 
						buttonGroupMovie.penMovie.show(false);
					} else {
						buttonGroupMovie.penMovie.show();
						selectedTool = null;
						//needToReturn = true;
					}
					break;
				case buttonGroupMovie.manageMovie:
					if (buttonGroupMovie.manageMovie.defaultButton != buttonGroupMovie.manageMovie.selectedButton) {
						
						if (buttonGroupMovie.manageMovie.defaultButton == buttonGroupMovie.manageMovie.frontMovie) {
							dispatchEvent(new ManagaEvent(ManagaEvent.BRING_TO_FRONT));
						} else if (buttonGroupMovie.manageMovie.defaultButton == buttonGroupMovie.manageMovie.backMovie) {
							dispatchEvent(new ManagaEvent(ManagaEvent.SEND_TO_BACK));
						}
						
						//} else if (buttonGroupMovie.manageMovie.defaultButton == buttonGroupMovie.manageMovie.clearMovie) {
							//dispatchEvent(new ManagaEvent(ManagaEvent.CLEAR_ALL));
						//}
						needToReturn = true;
					} else if (buttonGroupMovie.manageMovie.stageClicked && buttonGroupMovie.manageMovie.isShowing) {
						buttonGroupMovie.manageMovie.show(false);
						
					}
					
					break;
			}
			if (currentTool != selectedTool) {
				currentTool = selectedTool;
			} else {
				currentTool = null;
			}
			if (buttonGroupMovie.toggledButton != buttonGroupMovie.typeMovie && buttonGroupMovie.toggledButton != buttonGroupMovie.manageMovie) {
				dispatchEvent(e);
			}
			if (needToReturn) {
				return;
			}
			if (currentTool) {
				TweenLite.to(currentTool, 0.2, { autoAlpha: 1, overwrite: true } );
			} else {
				if (buttonGroupMovie.toggledButton != buttonGroupMovie.penMovie && selectedTool != typeToolMovie
						&& buttonGroupMovie.toggledButton != buttonGroupMovie.manageMovie) {
					buttonGroupMovie.toggledButton.toggled = false;
				}
			}
			
			typeToolMovie.setEnabled(selectedTool == typeToolMovie);
			
			if (buttonGroupMovie.toggledButton == buttonGroupMovie.penMovie) {
				//JSBridge.call("trackToolbrush");
				brushData = null;
				selectedTool = penTool[buttonGroupMovie.penMovie.selectedButton]
				switch (selectedTool) {
					case brushToolMovie:
						brushData = brushToolMovie.data;
						brushToolMovie.colorSliderMovie.toggled = false;
						break;
					case airBrushToolMovie:
						brushData = airBrushToolMovie.data;
						airBrushToolMovie.colorSliderMovie.toggled = false;
						break;
				}
				dispatchEvent(new BrushEvent(BrushEvent.ENABLE));
				
				
			} else if (buttonGroupMovie.toggledButton == buttonGroupMovie.eraserMovie) {
				brushData = null;
				brushData = eraserToolMovie.data;
				dispatchEvent(new BrushEvent(BrushEvent.ENABLE));
			}else {
				if (selectedTool == typeToolMovie) {
					dispatchEvent(new FontTypeEvent(FontTypeEvent.ADD_TEXT));
				}
				dispatchEvent(new BrushEvent(BrushEvent.DISABLE));
			}
		}
		
	}

}