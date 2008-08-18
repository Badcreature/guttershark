package net.guttershark.util 
{
	
	import flash.utils.Dictionary;

	/**
	 * The Assert class assists with validating arguments and is a relief mechanism
	 * for having to write the same logic over and over when checking arguments.
	 * 
	 * <p>The default error that's thrown when a condition is not met is an
	 * ArgumentError. You can change what error is thrown by providing the exceptionType
	 * parameter.</p>
	 * 
	 * @example	Using the Assert class:
	 * <listing>	
	 * public function setItems(array:Array, maxCount:int)
	 * {
	 *     Assert.NotNullOrEmpty(array, "Parameter array cannot be null or empty");
	 *     Assert.NotNull(maxCount, "Parameter maxCount cannot be null");
	 * }
	 * </listing>
	 */
	public class Assert 
	{
			
		/**
		 * Check the message passed in any of these static methods.
		 */
		private static function checkMessage(message:String):void
		{
			if(!message || message == "") throw new ArgumentError("Parameter message cannot be null");
		}
		
		/**
		 * Throws the error, depending ont he exceptionType.
		 */
		private static function throwError(message:String, exceptionType:Class):void
		{
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
		 * Check to see if an array is null or empty.
		 * @param	array	An array to validate that it's not null, and not empty.
		 * @param	message	A message to use for an ArgumentError.
		 * @param	exceptionType	The class of the exception type you want to throw. Default is ArgumentError if not specified.
		 * @throws	ArgumentError	If array is null.
		 * @throws 	ArgumentError	If message is null.
		 */
		public static function NotNullOrEmpty(array:Array, message:String, exceptionType:Class = null):void
		{
			checkMessage(message);
			if(array == null || array.length < 1) throwError(message,exceptionType);
		}
		
		/**
		 * Check that the object is not null.
		 * @param	object	The object to check.
		 * @param	message	A message to use for an ArgumentError.
		 * @param	exceptionType	The class of the exception type you want to throw. Default is ArgumentError if not specified.
		 * @throws	ArgumentError	If object is null.
		 * @throws 	ArgumentError	If message is null.
		 */
		public static function NotNull(object:*, message:String, exceptionType:Class = null):void
		{
			checkMessage(message);
			if(object == null) throwError(message,exceptionType);
		}
		
		/**
		 * Check that a target number is greater than a minimum amount.
		 * @param	target	The target number.
		 * @param	minimum	The minimum the target can be.
		 * @param	message	A message to use for an ArgumentError.
		 * @param	exceptionType	The class of the exception type you want to throw. Default is ArgumentError if not specified.
		 * @throws	ArgumentError	If object is null.
		 * @throws 	ArgumentError	If message is null. 
		 */
		public static function GreaterThan(target:Number, minimum:Number, message:String, exceptionType:Class = null):void
		{
			checkMessage(message);
			if(target < minimum) throwError(message,exceptionType);
		}
		
		/**
		 * Check that an object is a compatible instance, or interface of a certain class.
		 * @param	object	The object to check.
		 * @param	type	The Class that object needs to be an instance of in order to pass the test.
		 * @param	message	A message to use for an ArgumentError.
		 * @param	exceptionType	The class of the exception type you want to throw. Default is ArgumentError if not specified.
		 * @throws	ArgumentError	If object is null.
		 * @throws 	ArgumentError	If message is null.
		 */
		public static function Compatible(object:*, type:Class, message:String, exceptionType:Class = null):void
		{
			checkMessage(message);
			if(!(object is type)) throwError(message,exceptionType);
		}
		
		/**
		 * Assert a boolean expression. If the expression is false an error is raised.
		 * @param	expression	An expression as a boolean.
		 * @param	message	A message to use for an Error.
		 * @param	exceptionType	The class of the exception type you want to throw. Default is ArgumentError if not specified.
		 * @throws	ArgumentError	If object is null.
		 * @throws 	ArgumentError	If message is null.
		 */
		public static function State(expression:Boolean, message:String, exceptionType:Class = null):void
		{
			checkMessage(message);
			if (!expression) throwError(message,exceptionType);
		}
		
		/**
		 * Assert that a dictionary has keys that are only of the specified type.
		 * @param	dictionary	The dictionary to validate.
		 * @param	type	The class type that each key should be.
		 * @param	message	A message to use for an Error.
		 * @param	exceptionType	The class of the exception type you want to throw. Default is ArgumentError if not specified.
		 * @throws 	ArgumentError	If message is null.
		 * @throws	Error	If a key in the dictionary is not of the specified type.
		 */
		public static function DictionaryKeysOfType(dictionary:Dictionary, type:Class, message:String, exceptionType:Class = null):void
		{
			checkMessage(message);
			for(var key:Object in dictionary)
			{
				if(!(key is type)) throwError(message,exceptionType);
			}			
		}
		
		/**
		 * Assert that the passed value is true.
		 * @param	val	The boolean value to assert.
		 * @param	message	The message to throw if the assertion is false.
		 * @param	exceptionType	The exception type to throw if there is an error.
		 */
		public static function True(val:Boolean, message:String, exceptionType:Class = null):Boolean
		{
			checkMessage(message);
			if(!val) throwError(message,exceptionType);
			return true;
		}
		
		/**
		 * Assert that the passed value is false.
		 * @param	val	The boolean value to assert.
		 * @param	message	The message to throw if the assertion is false.
		 * @param	exceptionType	The exception type to throw if there is an error.
		 */
		public static function False(val:Boolean, message:String, exceptionType:Class = null):Boolean
		{
			checkMessage(message);
			if(val) throwError(message,exceptionType);
			return true;
		}
	}
}