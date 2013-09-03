package com.ctp.view.components.drawingboard {
	
	import com.ctp.view.events.ManagaEvent;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author tram.nguyen
	 */
	
	public class ConfirmBox extends ConfirmUI {
		
		private static var _instance:ConfirmBox;
		private var _stage:Sprite;
		
		//private var content:DisplayObject;
		
		
		
		public function ConfirmBox(singleton:Singleton) {
			//--- init ---//
			if (singleton == null){
				throw new Error("ConfirmBox is a singleton class.  ConfirmBox via ''ConfirmBox.instance''.");
			}
		}
		
		public function init():void {
			
			
			visible = false;
			alpha = 0;
			_stage.addChild(this);
			
			noButton.addEventListener(MouseEvent.CLICK, noButtonClickHandler);
			yesButton.addEventListener(MouseEvent.CLICK, noButtonClickHandler);
			//add event handler
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveHandler);
		}
		
		private function onRemoveHandler(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveHandler);
			
		}
		
		public function initStage($stage:Sprite):void 
		{
			_stage = $stage;
			
			init();
		}
		
		private function addedToStageHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
		}
		
		private function stageClickHandler(e:MouseEvent):void {
			if (alpha == 1 && this.hitTestPoint(stage.mouseX, stage.mouseY) == false) {
				noButtonClickHandler(null);
			}
		}
		
		private function noButtonClickHandler(e:MouseEvent):void {
			TweenLite.to(this, 0.2, { autoAlpha: 0 } );
			stage.removeEventListener(MouseEvent.CLICK, stageClickHandler);
		}
		
		public function show(message: String): void {
			//trace(ConfirmBox.instance);
			messageMovie.gotoAndPlay(message);
			//trace(messageMovie);
			if (message == ManagaEvent.CLEAR_ALL) {
				yesButton.y = noButton.y = 37;
			} else {
				yesButton.y = noButton.y = 27;
			}
			TweenLite.to(this, 0.2, { autoAlpha: 1 } );
			stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
		}
		
		//Singleton model
		public static function get instance():ConfirmBox {
 			if (ConfirmBox._instance == null){
				ConfirmBox._instance = new ConfirmBox(new Singleton());
			}
 			return ConfirmBox._instance;
 		}
		
	}
}

class Singleton { }