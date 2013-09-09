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
	
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
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
		//public var uploadPhotoMovie: UploadPhotoPopup = new UploadPhotoPopup();
		public var clipartMovie: ClipartPanel = new ClipartPanel();
		
		//public var clearToolMovie:ClearButton = new ClearButton();
		
		public var currentTool: * = null;
		
		public var fontTypeData: FontTypeInfo = new FontTypeInfo();
		
		private var _data: BrushInfo = new BrushInfo();
		public var brushData: BrushInfo;
	
		private var penTool: Dictionary = new Dictionary(true);
		
		private var tracker:AnalyticsTracker;
		
		public function ToolBar() {
			
			//uploadPhotoMovie.closeButton.addEventListener(MouseEvent.CLICK, closeSubTool);
			//uploadPhotoMovie.addEventListener(UploadPhotoEvent.COMPLETE, uploadPhotoCompleteHandler);
			
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
			
			if (stage) {
				init();
			}else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			tracker = new GATracker(this, "UA-34374356-3", "AS3", false);
		}
		
		//private function changeColorShapeHandler(e:ShapeEvent):void {
			//dispatchEvent(e);
		//}
		//
		//private function addShapeHandler(e:ShapeEvent):void {
			//dispatchEvent(e);
		//}

		private function uploadPhotoCompleteHandler(e:UploadPhotoEvent):void {
			if (e.ptype == "draw") {
				closeSubTool();
				dispatchEvent(e);
			}
		}
		
		//public function getShape(): MovieClip {
			//return shapesMenuMovie.getShape();
		//}
		
		public function getTextBounds(): Rectangle {
			return typeToolMovie.selectedBounds;
		}
		
		public function getUploadedPhoto(): Bitmap {
			//return uploadPhotoMovie.uploadedPhoto;
			return UploadPhotoPopup.instance.uploadedPhoto;
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
			
			eraserToolMovie.x  = 151;
			eraserToolMovie.y  = 61;
			addChild(eraserToolMovie);
			
			//addChild(paintBucketToolMovie);
			//revise by rick
			
			typeToolMovie.x = 18.35;
			typeToolMovie.y = -65.75;
			
			addChild(typeToolMovie);
			
			//uploadPhotoMovie.x = 158;
			//uploadPhotoMovie.y = -122.85;
			//addChild(uploadPhotoMovie);
			
			UploadPhotoPopup.instance.initStage(this);
			UploadPhotoPopup.instance.type = "draw";
			UploadPhotoPopup.instance.x = 158;
			UploadPhotoPopup.instance.y = -122.85;
			
			UploadPhotoPopup.instance.closeButton.addEventListener(MouseEvent.CLICK, closeSubTool);
			UploadPhotoPopup.instance.addEventListener(UploadPhotoEvent.COMPLETE, uploadPhotoCompleteHandler);
			
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
			
			if (currentTool == clipartMovie || currentTool == UploadPhotoPopup.instance ) {
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
				case buttonGroupMovie.eraserMovie:
					
					selectedTool = eraserToolMovie;
					break;
				case buttonGroupMovie.clearMovie:
					try
					{
						tracker.trackEvent("/idea-submission", "click", "clear-all-button-icp");
					}
					catch (error:Error)
					{
						trace(error);
					}
					dispatchEvent(new ManagaEvent(ManagaEvent.CLEAR_ALL));
					break;	
				case buttonGroupMovie.typeMovie:
					//fontdata 
					try
					{
						tracker.trackEvent("/idea-submission", "click", "text-button-icp");
					}
					catch (error:Error)
					{
						trace(error);
					}
					selectedTool = typeToolMovie;
					typeToolMovie.data = fontTypeData;
					break;
				case buttonGroupMovie.uploadImageMovie:
					
					try
					{
						tracker.trackEvent("/idea-submission", "click", "upload-button-icp");
					}
					catch (error:Error)
					{
						trace(error);
					}
					
					selectedTool = UploadPhotoPopup.instance;
					UploadPhotoPopup.instance.reset();
					break;
				case buttonGroupMovie.clipartMovie:
					
					
					try
					{
						tracker.trackEvent("/idea-submission", "click", "clipart-button-icp");
					}
					catch (error:Error)
					{
						trace(error);
					}
					
					
					selectedTool = clipartMovie;
					clipartMovie.reset();
					break;
				case buttonGroupMovie.penMovie:
					
					try
					{
						tracker.trackEvent("/idea-submission", "click", "brush-button-icp");
					}
					catch (error:Error)
					{
						trace(error);
					}
					
					if (buttonGroupMovie.penMovie.stageClicked == false) {
						selectedTool = penTool[buttonGroupMovie.penMovie.selectedButton]
					}
					if (buttonGroupMovie.penMovie.isShowing) { 
						buttonGroupMovie.penMovie.show(false);
					} else {
						buttonGroupMovie.penMovie.show();
						selectedTool = null;
					}
					break;
				case buttonGroupMovie.manageMovie:
					
					try
					{
						tracker.trackEvent("/idea-submission", "click", "order-button-icp");
					}
					catch (error:Error)
					{
						trace(error);
					}
					
					
					
					if (buttonGroupMovie.manageMovie.defaultButton != buttonGroupMovie.manageMovie.selectedButton) {
						
						if (buttonGroupMovie.manageMovie.defaultButton == buttonGroupMovie.manageMovie.frontMovie) {
							dispatchEvent(new ManagaEvent(ManagaEvent.BRING_TO_FRONT));
						} else if (buttonGroupMovie.manageMovie.defaultButton == buttonGroupMovie.manageMovie.backMovie) {
							dispatchEvent(new ManagaEvent(ManagaEvent.SEND_TO_BACK));
						}

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