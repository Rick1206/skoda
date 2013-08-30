package com.pyco.external {
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author tram.nguyen
	 */
	public class JSBridge {
		
		/**
		 * Calls a function exposed by the Flash Player container, passing zero or more arguments.  
		   If the function is not available, the call returns null; 
		   otherwise it returns the value provided by the function.
		 * @param	functionName	The alphanumeric name of the function to call in the container.
		 * @param	...rest			The arguments to pass to the function in the container. 
		  							You can specify zero or more parameters, separating them with commas.
		 */
		public static function call(functionName:String, ...rest): * {
			if (ExternalInterface.available && functionName) {
				var value: *;
				try {
					rest.splice(0, 0, functionName);
					value = ExternalInterface.call.apply(null, rest);
				} catch (e: Error) {
					return null;
				}
				return value;
			}
			return null;
		}
		
		/**
		 * Registers an ActionScript method as callable from the container
		 * @param	functionName	The name by which the container can invoke the function.
		 * @param	closure			The function closure to invoke.
		 */
		public static function addCallback(functionName:String, closure:Function): void {
			if (ExternalInterface.available) {
				ExternalInterface.addCallback(functionName, closure);
			}
		}
		
	}

}