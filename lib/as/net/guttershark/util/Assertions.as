package net.guttershark.util 
{

	/**
	 * The Assertions class is a singleton that provides assertions for conditionals,
	 * and relieve's defensive programming for methods that require arguments.
	 * 
	 * <p>All of the methods can be used for conditional assertions.</p>
	 * @example Using assertions for conditionals:
	 * 
	 * <listing>	
	 * var ast:Assertions = Assertions.gi();
	 * var t:String = " ";
	 * if(ast.emptyString(t)) trace("it's empty");
	 * t = "word";
	 * if(ast.emptyString(t)) trace("doh"); //this wont trace, because the assertion evaluates to false.
	 * </listing>
	 * 
	 * <p>You can also use the assertion class as defense when checking for valid
	 * method arguments and throw errors.</p>
	 * 
	 * @example Using the assertions class for method argument defense:
	 * <listing>	
	 * var ast:Assertions = Assertions.gi();
	 * function setSomething(val:Number):void
	 * {
	 *     ast.notNull(val,"Parameter val cannot be null"); //throws argument error if val is null
	 *     somthing = val;
	 * }
	 * </listing>
	 * 
	 * <p>You can also change the exception type that get's thrown if an assertion fails.</p>
	 * @example Changing the exception type:
	 * <listing>	
	 * var ast:Assertions = Assertions.gi();
	 * function setSomething(mc:MovieClip):void
	 * {
	 *    ast.compatible(mc,MovieClip,"Parameter val must be a MovieClip",TypeError);
	 * }
	 * </listing>
	 * 
	 * @example	Using the Assertions class:
	 * <listing>	
	 * public class MyMC extends CoreClip
	 * {
	 *     
	 *     //protected var ast:Assertion; //ast is a protected variable on CoreClip, and CoreSprite.
	 *     
	 *     //example of using the assertion methods to validate a parameter, and throw and error if it evaluates to false.
	 *     //the default Exception type is ArgumentError.
	 *     public function setEmail1(email:String):void
	 *     {
	 *         ast.email(email,"Parameter email must be a valid email address"); //throws an ArgumentError
	 *     }
	 *     
	 *     //example of using a custom exception class for parameter defense.
	 *     public function setEmail2(email:String):void
	 *     {
	 *         ast.email(email,"Parameter email must be a valid email address",MyCustomExceptionClass);
	 *     }
	 *     
	 *     //example of using the assertion methods for a boolean conditional
	 *     public function setEmail3(email:String):void
	 *     {
	 *         if(ast.notEmail(email)) return;
	 *     }
	 *     
	 *     public function setSomeValue(value:Object):void
	 *     {
	 *         ast.notNil(value,"Parameter value cannot be null"); //argument error if value is null
	 *     }
	 *     
	 *     public function setSomeArray(array:Array):void
	 *     {
	 *         ast.notNilOrEmpty(array,"Parameter array cannot be null"); //argument error if array is null or length==0
	 *     }
	 * }
	 * </listing>
	 */
	final public class Assertions
	{
		
		/**
		 * Singleton instance.
		 */	
		private static var inst:Assertions;
		
		/**
		 * A function delegate you can define, which will
		 * be called when an assertion fails - this is intended
		 * to be used if you wanted to post the assertion
		 * to an http service for logging errors.
		 * 
		 * @example Using the onAssertionFail delegate:
		 * <listing>	
		 * var ast:Assertions = Assertions.gi();
		 * ast.onAssertionFail = onAssertionFail;
		 * private function onAssertionFail(msg:String):void
		 * {
		 *     trace(msg);
		 * }
		 * </listing>
		 */
		public var onAssertionFail:Function;
		
		/**
		 * @private
		 */
		public function Assertions()
		{
			Singleton.assertSingle(Assertions);
		}
		
		/**
		 * Singleton access.
		 */
		public static function gi():Assertions
		{
			if(!inst) inst = Singleton.gi(Assertions);
			return inst;
		}
		
		/**
		 * Throws the error, depending on the exceptionType.
		 */
		private function throwError(message:String, exceptionType:Class):void
		{
			try{if(onAssertionFail!==null) onAssertionFail(message);}
			catch(e:ArgumentError){trace("WARNING: Your onAssertionFail function must accept one parameter - a message string.");}
			switch(exceptionType)
			{
				case null:
					throw new ArgumentError(message);
					break;
				default:
					throw new exceptionType(message);
					break;
			}
		}
		
		/**
		 * Assert that a value is greater than a minimum number.
		 * 
		 * @param value The value to test.
		 * @param minimum The minimum number that the value must be greater than.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function greater(value:Number, minimum:Number=-1,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(value < minimum) throwError(message,exceptionType);
			return (value > minimum);
		}
		
		/**
		 * Assert that a value is smaller than a maximum number.
		 * 
		 * @param value The value to test.
		 * @param maximum The maximum number that the value must be smaller than.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function smaller(value:Number,maxmimum:Number=0,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(value > maxmimum) throwError(message,exceptionType);
			return (value < maxmimum);
		}
		
		/**
		 * Assert that a value is equal to another value.
		 * 
		 * @param value The value to test.
		 * @param otherValue The other value to compare with value (this is actually typed as &#42;, but asdocs changes it to String for some reason).
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function equal(value:*,otherValue:*,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(value!==otherValue) throwError(message,exceptionType);
			return (value===otherValue);
		}
		
		/**
		 * Assert that a value is defferent from another value.
		 * 
		 * @param value The value to test.
		 * @param otherValue The other value to compare with value (this is actually typed as &#42, but asdocs changes it to String for some reason).
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function different(value:*,otherValue:*,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(value===otherValue) throwError(message,exceptionType);
			return (value!==otherValue);
		}
		
		/**
		 * Assert if an Array is nil or empty.
		 * 
		 * @param array The array to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function nilOrEmpty(array:Array,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(!nil(array) && array.length>0) throwError(message,exceptionType);
			return (nil(array) || array.length==0);
		}
		
		/**
		 * Assert if an Array is not nil or empty.
		 * 
		 * @param array The array to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function notNilOrEmpty(array:Array, message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(nil(array) || array.length==0) throwError(message,exceptionType);
			return !(nil(array) || array.length==0);
		}
		
		/**
		 * Assert if an object is nil.
		 * 
		 * @param obj The object to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function nil(obj:*,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(!(obj === null || obj === undefined || !obj)) throwError(message, exceptionType);
			if(obj === null || obj === undefined || !obj) return true;
			return false;
		}
		
		/**
		 * Assert if an object is not nil.
		 * 
		 * @param object The object to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function notNil(object:*,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(nil(object)) throwError(message,exceptionType);
			return !(nil(object));
		}
		
		/**
		 * Assert if an object is compatible with another type.
		 * 
		 * @param obj The object to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function compatible(obj:*,type:Class,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(!(obj is type)) throwError(message,exceptionType);
			return (obj is type);
		}
		
		/**
		 * Assert if an object is not compatible with another type.
		 * 
		 * @param obj The object to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function notCompatible(obj:*, type:Class, message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if((compatible(obj,type))) throwError(message,exceptionType);
			return (!(compatible(obj,type)));
		}
		
		/**
		 * Assert that a string contains another string.
		 * 
		 * @param str The string to search in.
		 * @param pat The pattern that will be searched for in str.
		 */
		public function contains(str:String,pat:String,message:String=null,exceptionType:Class=null):Boolean
		{
			if(message) if(nil(str) || smaller(str.indexOf(pat),0)) throwError(message,exceptionType);
			if(nil(str)) return false;
			return !smaller(str.indexOf(pat),0);
		}
		
		/**
		 * Assert if a string is an email address.
		 * 
		 * @param str The string to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function email(str:String,message:String=null,exceptionType:Class=null):Boolean
		{
			var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			if(message) if(!emailExpression.test(str)) throwError(message,exceptionType);
			return emailExpression.test(str);
		}
		
		/**
		 * Assert if a string is a phone number.
		 * 
		 * @param str The string to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function phone(str:String,message:String=null,exceptionType:Class=null):Boolean
		{
			var phoneExpression:RegExp = /^((\+\d{1,3}(-| )?\(?\d\)?(-| )?\d{1,3})|(\(?\d{2,3}\)?))(-| )?(\d{3,4})(-| )?(\d{4})(( x| ext)\d{1,5}){0,1}$/i;
			if(message) if(!phoneExpression.test(str)) throwError(message,exceptionType);
			return phoneExpression.test(str);
		}
		
		/**
		 * Assert a string as being empty (zero characters or all spaces).
		 * 
		 * @param str The string to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function emptyString(str:String,message:String=null,exceptionType:Class=null):Boolean
		{
			var r:RegExp = /^ {0,}$/i;
			if(message) if(!r.test(str)) throwError(message,exceptionType);
			return r.test(str);
		}
		
		/**
		 * Assert a string as being not empty (zero characters or all spaces).
		 * 
		 * @param str The string to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function notEmptyString(str:String,message:String=null,exceptionType:Class=null):Boolean
		{
			var r:RegExp = /^ {0,}$/i;
			if(message) if(r.test(str)) throwError(message,exceptionType);
			return !r.test(str);
		}
		
		/**
		 * Assert that a string has all number characters.
		 * 
		 * @param str The string to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function numberString(str:String,message:String=null,exceptionType:Class=null):Boolean
		{
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			if(message) if(nil(str) || (!regx.test(str))) throwError(message,exceptionType);
			if(nil(str)) return false;
			return regx.test(str);
		}
		
		/**
		 * Assert that a string does not have all number characters.
		 * 
		 * @param str The string to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function notNumberString(str:String,message:String=null,exceptionType:Class=null):Boolean
		{
			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			if(message) if(notNil(str) && (regx.test(str))) throwError(message,exceptionType);
			if(nil(str)) return true;
			return !regx.test(str);
		}
		
		/**
		 * Assert that a string is a po box. (PO ,P O,P.O,P. O,p o,p.o,p. o,Box,Post Office,post office).
		 * 
		 * @param address The string to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function pobox(address:String,message:String=null,exceptionType:Class=null):Boolean
		{
			var look:Array = ["PO ","P O","P.O","P. O", "p o","p.o","p. o","Box","Post Office","post office"];
			var len:Number = look.length;
			var i:int;
			if(message)
			{
				for(i = 0;i < len; i++) if(address.indexOf(look[i]) != -1) return true;
				throwError(message,exceptionType);
			}
			for(i = 0;i < len; i++) if(address.indexOf(look[i]) != -1) return true; 
			return false;
		}
		
		/**
		 * Assert that a given state abbreviation is a valid state, according to the 
		 * usps list of abbreviations (http://www.usps.com/ncsc/lookups/abbr_state.txt) - including
		 * military state abbreviations.
		 * 
		 * @param state A state abbreviation to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function stateAbbrev(state:String,message:String=null,exceptionType:Class=null):Boolean
		{
			var states:Array = [
				"AL","AK","AS","AZ",
				"AR","CA","CO","CT","DE","DC",
				"FM","FL","GA","GU","HI","ID",
				"IL","IN","IA","KS","KY","LA",
				"ME","MH","MD","MA","MI","MN",
				"MS","MO","MT","NE","NV","NH",
				"NJ","NM","NY","NC","ND","MP",
				"OH","OK","OR","PW","PA","PR",
				"RI","SC","SD","TN","TX","UT",
				"VT","VI","VA","WA","WV","WI","WY",
				"AE","AA","AP"
			];
			var i:int = 0;
			var l:int = 62;
			if(message)
			{
				for(i;i<l;i++) if(state.toUpperCase()==states[i]) return true;
				throwError(message,exceptionType);
			}
			for(i;i<l;i++) if(state.toUpperCase()==states[i]) return true;
			return false;
		}
		
		/**
		 * Assert that a string is a web URL.
		 * 
		 * @param str The string to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function url(str:String,message:String=null,exceptionType:Class=null):Boolean
		{
			var v:Boolean = (str.substring(0,7) == "http://" || str.substring(0,8) == "https://");
			if(message) if(!v) throwError(message,exceptionType);
			return v;
		}
		
		/**
		 * Assert that a string is not a web URL.
		 * 
		 * @param str The string to evaluate.
		 * @param message A message to throw if the assertion evaluates to false.
		 * @param exceptionType The exceptionType to throw if an exception is being thrown.
		 */
		public function noturl(str:String,message:String=null,exceptionType:Class=null):Boolean
		{
			var v:Boolean = (str.substring(0,7) == "http://" || str.substring(0,8) == "https://");
			if(message) if(v) throwError(message,exceptionType);
			return !v;
		}
	}
}