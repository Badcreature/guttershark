package net.guttershark.util 
{
	import flash.utils.Dictionary;	
	
	/**
	 * The Assert class assists with validating arguments.
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
		 * Check to see if an array is empty.
		 * @param	
		 */
		public static function NullOrEmpty(array:Array, message:String):void
		{
			checkMessage(message);
			if(array == null || array.length < 1) throw new ArgumentError(message);
		}
		
		/**
		 * Check that the object is not null.
		 * @param	object	The object to check.
		 * @param	message	A message to use for an ArgumentError.
		 * @throws	ArgumentError	if object is null.
		 * @throws 	ArgumentError	If message is null.
		 */
		public static function NotNull(object:*, message:String):void
		{
			checkMessage(message);
			if(object == null) throw new ArgumentError(message);
		}
		
		/**
		 * Check that an object is a compatible instance, or interface of a certain class.
		 * @param	object	The object to check.
		 * @param	type	The Class that object needs to be an instance of in order to pass the test.
		 * @param	message	A message to use for an ArgumentError.
		 * @throws	ArgumentError	if object is null.
		 * @throws 	ArgumentError	If message is null.
		 */
		public static function Compatible(object:*, type:Class, message:String):void
		{
			checkMessage(message);
			if(!(object is type)) throw new ArgumentError(message);
		}
		
		/**
		 * Assert a boolean expression. If the expression is false an error is raised.
		 * @param	expression	An expression as a boolean.
		 * @param	message	A message to use for an Error.
		 * @throws	ArgumentError	if object is null.
		 * @throws 	ArgumentError	If message is null.
		 */
		public static function State(expression:Boolean, message:String):void
		{
			checkMessage(message);
			if (!expression) throw new Error(message);
		}
		
		/**
		 * Assert that a dictionary has keys that are only of the specified type.
		 * @param	dictionary	The dictionary to validate.
		 * @param	type	The class type that each key should be.
		 * @param	message	A message to use for an Error.
		 * @throws 	ArgumentError	If message is null.
		 * @throws	Error	If a key in the dictionary is not of the specified type.
		 */
		public static function DictionaryKeysOfType(dictionary:Dictionary, type:Class, message:String):void
		{
			checkMessage(message);
			for(var key:Object in dictionary)
			{
				if(!(key is type)) throw new Error(message);
			}			
		}
	}
}
