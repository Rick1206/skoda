package code{
	import flash.display.Stage;
	public class GlobalVars {
		

		public function GlobalVars(){
		}
		
		public static function getTime():Number{
			if (Stage.prototype.time != null){
				return Stage.prototype.time as Number;
			}else{
				return 0;
			}
		}
		
		public static function setTime(time:Number){
			Stage.prototype.time = time;
		}
		
		
	}
}