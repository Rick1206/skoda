package com.ctp.view.components {
	
	import com.adobe.images.JPGEncoder;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	//class
	import com.ctp.model.AppData;
	//Brush type
	import com.ctp.model.constant.BrushType;
	//object type
	import com.ctp.model.constant.ObjectType;
	
	import com.ctp.view.components.drawingboard.ConfirmBox;
	import com.ctp.view.components.drawingboard.paint.BrushBoard;
	//import com.ctp.view.components.drawingboard.PopupWindow;
	import com.ctp.view.components.drawingboard.resizing.ImageResizing;
	import com.ctp.view.components.drawingboard.resizing.ObjectResizing;
	//import com.ctp.view.components.drawingboard.resizing.ShapeResizing;
	import com.ctp.view.components.drawingboard.resizing.TextResizing;
	import com.ctp.view.components.drawingboard.ToolBar;
	import com.ctp.view.components.drawingboard.VersionUI;
	
	import com.ctp.view.events.BrushEvent;
	import com.ctp.view.events.ClipartEvent;
	import com.ctp.view.events.FontTypeEvent;
	import com.ctp.view.events.ManagaEvent;
	import com.ctp.view.events.ObjectResizingEvent;
	//import com.ctp.view.events.ShapeEvent;
	import com.ctp.view.events.UploadPhotoEvent;
	
	import com.dynamicflash.util.Base64;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.TweenMax;
	import com.greensock.plugins.TweenPlugin;
	import com.pyco.external.JSBridge;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	
	import com.ctp.view.components.submitinspire.UploadInspirePhoto;
	
	
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;
	
	import code.tool.RollTool;
	import code.events.QuesEvent;
	import code.GlobalVars;
	//import com.ctp.view.events.UploadPhotoEvent;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class DrawingBoard extends Sprite {
		
		public var toolBarMovie: ToolBar = new ToolBar();
		//public var boardMovie: Sprite = new Sprite();
		public var contentMovie: Sprite = new Sprite();
		public var brushMovie: BrushBoard = new BrushBoard();
		public var confirmMovie: ConfirmBox;
		//public var versionMovie: VersionUI = new VersionUI();
		
		//public var popupMovie: PopupWindow = new PopupWindow();
		private var selectedObject: ObjectResizing;
		
		private var numCusDis:Number = -314;
		//-- submission --//
		private var strDrawPic:String = "";
		private var strUserTalent:String = "";
		private var strUserInspie:String = "";
		private var strDrawName:String = "";
		private var strDrawDesc:String = "";
		
		//-- user profile --//
		private var strHeadPic:String = "";
		private var strTypeNum:String = "";
		private var strUserName:String = "";
		
		private var intPercentage:int;
		
		private var mcChoSwf:MovieClip;
		
		public function DrawingBoard() {
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			//versionMovie.versionText.text = "v 1.3";
			//图片集合
			toolBarMovie.addEventListener(ClipartEvent.ADD_IMAGE, addClipartImageHandler);
			toolBarMovie.addEventListener(ClipartEvent.ADD_IMAGE_AT_CENTER, addClipartImageHandler);
			//图片
			toolBarMovie.addEventListener(UploadPhotoEvent.COMPLETE, uploadPhotoCompleteHandler);
			
			//笔刷+橡皮擦
			toolBarMovie.addEventListener(BrushEvent.ENABLE, brushEnableHandler);
			toolBarMovie.addEventListener(BrushEvent.DISABLE, brushEnableHandler);
			//文字
			toolBarMovie.addEventListener(FontTypeEvent.CHANGE, fontTypeChangeHandler);
			toolBarMovie.addEventListener(FontTypeEvent.ADD_TEXT, addTextHandler);
			
			
			//？
			toolBarMovie.addEventListener(ToggleButtonBase.TOGGLE_BUTTON_CLICK, toggleButtonClickHandler);
			
			
			//-- send-to-back --// 层级关系
			toolBarMovie.addEventListener(ManagaEvent.SEND_TO_BACK, manageHandler);
			toolBarMovie.addEventListener(ManagaEvent.BRING_TO_FRONT, manageHandler);
			toolBarMovie.addEventListener(ManagaEvent.CLEAR_ALL, manageHandler);
			
			//confirmMovie.yesButton.addEventListener(MouseEvent.CLICK, yesButtonClickHandler);
			//confirmMovie.init();
			
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			}
			
			//js event
			//showStudentPopup(null);
			//JSBridge.addCallback("getImage", getImage);
			//JSBridge.addCallback("showStudentPopup", showStudentPopup);
			//showStudentPopup("INITIALIZING: Adobe Flex Compiler SHell (fcsh)");
			
		}
		
		private function addedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			//this.visible = false;
			//this.alpha = 0;
			init();
		}
		
		//--- init ---//
		private function init(): void {
			
			AppData.parameters = stage.loaderInfo.parameters;
			//AppData.parameters.debug = "true";
			
			//AppData.parameters.exportedImage = "images/Sunset.jpg";
			
			//-- loading --//
			
			var StrBgUrl:String = AppData.parameters.bgImage ? AppData.parameters.bgImage : "../images/bg.jpg";
			
			var CloudSwf:String = AppData.parameters.cloudSwf ? AppData.parameters.cloudSwf : "cloud.swf";
			
			if (StrBgUrl) {
				var queue:LoaderMax = new LoaderMax({name:"mainQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
					queue.append( new ImageLoader(StrBgUrl, { name:"bg", container:this, alpha:0 } ) );
					//queue.append( new ImageLoader(CloudBgUrl, { name:"cloudbg", container:this, alpha:0 } ) );
					queue.append( new SWFLoader(CloudSwf, {name:"cloud",container:this,alpha:0}) );
				queue.load();
			}
			
			
			//boardMovie.x = -176;
			//boardMovie.y = -367;
			//addChild(boardMovie);
			//board
			boardMovie.contentMc.addChild(contentMovie);
			brushMovie.toolBarMovie = toolBarMovie;
			contentMovie.addChild(brushMovie);
			
			//contentMovie.x = -490;
			//testing shape
			//scbot.x = boardMovie.x;
			//scbot.y = boardMovie.y;
			
			toolBarMovie.x = -327.65;
			toolBarMovie.y = -378.4;
			//this.setChildIndex(toolBarMovie, 2);
			//stage.setChildIndex(toolBarMovie, 2);
			toolFrame.addChild(toolBarMovie);
			
			//trace("init");
			//addChild(confirmMovie);
			//trace(this.stage.);
			
			ConfirmBox.instance.initStage(this);
			//what about objecresizing
			ConfirmBox.instance.x = 165;
			ConfirmBox.instance.y = -200;
			ConfirmBox.instance.yesButton.addEventListener(MouseEvent.CLICK, yesButtonClickHandler);
			
			
			stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
			
			//add by rick
			btnSubmission.addEventListener(MouseEvent.CLICK, getImage);
			
			RollTool.setRoll(btnSubmission);
			RollTool.setRoll(btnInspire);
			RollTool.setRoll(btnTalent);
			RollTool.setRoll(btnGallery);
			
			btnTalent.addEventListener(MouseEvent.CLICK, onShowChooseHandler);
			btnInspire.addEventListener(MouseEvent.CLICK, onShowChooseHandler);
			btnGallery.addEventListener(MouseEvent.CLICK, onGotoGalleryHandler);
			
			//errorMc.visible = false;
			//-- debug mode --//
			//ChooseMc.visible = false;
			errorMc.visible = false;
			errorMc.alpha = 0;
			
			//userProfileMc.close();
		}
		
		private function onGotoGalleryHandler(e:MouseEvent):void 
		{
			navigateToURL(new URLRequest("http://www.baidu.com"), "_blank");
		}
		
		private function onShowChooseHandler(e:MouseEvent):void 
		{
			switch(e.currentTarget.name) {
				case "btnInspire":
					TweenMax.to(ChooseMc, 0.5, { autoAlpha:1 } );
					mcChoSwf.show("inspire");
					break;
				case "btnTalent":
					TweenMax.to(ChooseMc, 0.5, { autoAlpha:1 } );
					mcChoSwf.show("talent");
					break;
			}
		}
		
		private function errorHandler(event:LoaderEvent):void {
			trace("error");
		}
		
		private function completeHandler(event:LoaderEvent):void {
			TweenMax.to(mcLoading, .3, { alpha:0, onComplete:function() {
				removeChild(mcLoading);
				
				} } );
			
			var image:ContentDisplay = LoaderMax.getContent("bg");
				bgFrame.addChild(image);
			
			var cloudSwf:ContentDisplay = LoaderMax.getContent("cloud");
				mcChoSwf = cloudSwf.rawContent as MovieClip;	
				mcChoSwf.x = -547.5;
				mcChoSwf.y = -513;
				ChooseMc.addChild(mcChoSwf);
				
				mcChoSwf.addEventListener(QuesEvent.UPLOAD, onUploadUserInfoHanlder);
				
				TweenMax.to(image, 0.5, { alpha:1 } );
				TweenMax.to(mcChoSwf, 0.5, { alpha:1 } );
		}
		
		private function onUploadUserInfoHanlder(e:QuesEvent):void 
		{
			
			//trace(e.talent);
			//trace(e.talent);
			
			switch(e.talent) {
				case "1":
						tipsMc.status("develop");
					break;
				case "2":
						tipsMc.status("service");
					break;
				case "3":
						tipsMc.status("science");
					break;
			
			}
			
			TweenMax.to(ChooseMc, 0.5, { autoAlpha:0 } );
		}
		
		
		private function progressHandler(event:LoaderEvent):void {
			intPercentage = Math.round(event.target.progress * 100);
			mcLoading.percentText.text = intPercentage + "%";
			mcLoading.percentMovie.gotoAndStop(intPercentage);
		}
		
		
		private function toggleButtonClickHandler(e:Event):void {
			trace("toggleButtonClickHandler")
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
					ConfirmBox.instance.show(ManagaEvent.CLEAR_ALL);
					break;
			}
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
			
			//textResizing.x = bounds.x + bounds.width / 2;
			//textResizing.y = bounds.y + bounds.height / 2;
			
			textResizing.x = bounds.x;
			textResizing.y = bounds.y;
			
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
		
		public function getImage(e:Event):String {
			selectedObject = null;
			
			stageClickHandler(null);
			
			strDrawName = txtDrawName.text;
			strDrawDesc = txtDrawDesc.text;
			
			//"你还没选择挑战题目哦，快挑选一个吧！"
			//"你还没选择达人类型哦，这就选一个吧！"
			//"你的主意还没有名字哦，快起个名字吧！"
			//"你还没描述你的主意哦，说两句吧！"
			
			
			if (strDrawName == "") {
				
				errorMc.gotoAndStop(3);
				
				TweenMax.to(errorMc, .3, { autoAlpha:1 , onComplete:function() {
				
					TweenMax.to(errorMc, .3, { autoAlpha:0,delay:1.5 } );
					
					}} );
				
	
				return "";
			}
			
			if (strDrawDesc == "") {
				
				errorMc.gotoAndStop(4);
				
				TweenMax.to(errorMc, .3, { autoAlpha:1 , onComplete:function() {
				
					TweenMax.to(errorMc, .3, { autoAlpha:0,delay:1.5 } );
					
					}} );
					
					return "";
				
			}
			
			trace("q1:"+GlobalVars.getQ1());
			trace("q2:"+GlobalVars.getQ2());
			trace("q3:"+GlobalVars.getQ3());
			trace("q4:"+GlobalVars.getQ4());
			trace("q5:"+GlobalVars.getQ5());
			
			var bmd: BitmapData = new BitmapData(624, 624, false, 0xFFFFFF);
			bmd.draw(boardMovie);
			
			//-- test --//
			var bit:Bitmap = new Bitmap(bmd);
			bit.x = -1000;
			bit.y = -500;
			
			addChild(bit);

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
			//if (errorMc.visible) {
				//errorMc.visible = false;
			//}
			//trace(e.name);
			trace(e.currentTarget);
			trace("stage click");
			
			if (!userProfileMc.hitTestPoint(stage.mouseX, stage.mouseY)) {
				userProfileMc.close();
			}
			
			
			if (ConfirmBox.instance.visible || brushMovie.painEnabled) {
				return;
			}
			
			//if (toolBarMovie.shapesMenuOpening && selectedObject && selectedObject.type == ObjectType.SHAPE) {
				//return;
			//}

			if (e == null || toolBarMovie.buttonGroupMovie.hitTestPoint(stage.mouseX, stage.mouseY)) {
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
			
			//if (ConfirmBox.instance.messageMovie.totalFrames == confirmMovie.messageMovie.currentFrame) {
			if (ConfirmBox.instance.messageMovie.totalFrames == ConfirmBox.instance.messageMovie.currentFrame) {
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
					imageResizing.x = ObjectResizing.MAX_WIDTH / 2;
					imageResizing.y = ObjectResizing.MAX_HEIGHT / 2;
				} else {
					imageResizing.x = this.mouseX - boardMovie.x;
					imageResizing.y = this.mouseY - boardMovie.y;
				}
			
			} else {
				imageResizing.defaultWidth = 660;
				
				imageResizing.x = ObjectResizing.MAX_WIDTH/2;
				imageResizing.y = ObjectResizing.MAX_HEIGHT/2;
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
			//confirmMovie.show(selectedObject.type);
			
			ConfirmBox.instance.show(selectedObject.type);
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