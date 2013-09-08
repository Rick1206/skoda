package code{
	import flash.display.Stage;
	public class GlobalVars {
		

		public function GlobalVars(){
		}
		
		public static function getQ1():String{
			if (Stage.prototype.q1 != null){
				return Stage.prototype.q1 as String;
			}else{
				return "";
			}
		}
		
		public static function setQ1(q1:String){
			Stage.prototype.q1 = q1;
		}
		
		public static function getQ2():String{
			if (Stage.prototype.q2 != null){
				return Stage.prototype.q2 as String;
			}else{
				return "";
			}
		}
		
		public static function setQ2(q2:String){
			Stage.prototype.q2 = q2;
		}
		
		public static function getQ3():String{
			if (Stage.prototype.q3 != null){
				return Stage.prototype.q3 as String;
			}else{
				return "";
			}
		}
		
		public static function setQ3(q3:String){
			Stage.prototype.q3 = q3;
		}
		
		public static function getQ4():String{
			if (Stage.prototype.q4 != null){
				return Stage.prototype.q4 as String;
			}else{
				return "";
			}
		}
		
		public static function setQ4(q4:String){
			Stage.prototype.q4 = q4;
		}
		
		public static function getQ5():String{
			if (Stage.prototype.q5 != null){
				return Stage.prototype.q5 as String;
			}else{
				return "";
			}
		}
		
		public static function setQ5(q5:String){
			Stage.prototype.q5 = q5;
		}
		
	}
}