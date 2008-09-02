package net.guttershark.util.validators
{
	/**	 * Basic Type Validation	 */	public class TypeValidator 
	{
		/* TODO:		 * Dictionary		 * XMLList		 * XMLNode		 * Sprite		 * MovieClip		 * DisplayObject		 * etc ...		 */		public static const BOOLEAN:String = "boolean";
		public static const DATE:String = "date";
		public static const ERROR:String = "error";
		public static const FUNCTION:String = "function";
		public static const INT:String = "int";
		public static const NULL:String = "null";
		public static const NUMBER:String = "number";
		public static const OBJECT:String = "object";
		public static const STRING:String = "string";
		public static const UINT:String = "uint";
		public static const UNDEFINED:String = "undefined";
		public static const XML:String = "xml";		protected static const IS_OCTAL:RegExp = /^0[0-7]+$/i;
		protected static const IS_NUMBER:RegExp = /^-?(([0-9]+[.]?[0-9]*)|(.[0-9]+))$/;
		protected static const IS_BOOLEAN:RegExp = /^((true)|(false))$/i;
		protected static const IS_HEX:RegExp = /^0x[0-9a-f]+$/i;		
		/**		 * Compares the types of two objects.		 * @return <code>true</code> if the two objects are the same primitive type.		 */		public static function compare(o1:*, o2:*):Boolean 
		{			return typeof(o1) == typeof(o2);		}
		/**		 * Checks if the passed-in object is an explicit instance of the passed-in class.		 * @return <code>true</code> if the passed-in object is an explicit instance of the passed-in class.		 */		public static function isExplicitInstanceOf(o:*, c:*):Boolean 
		{			if (isPrimitive(o)) 
			{				var tof:String = typeof(o) ;				if (c == Function(String)) 
				{					return (tof == STRING);  				}     			else if (c == Function(Number)) 
				{					return (tof == NUMBER);				}    			else if (c == Function(Boolean)) 
				{					return (tof == BOOLEAN);  				} 			} 			return o is c;		}
		/**		 * Checks if the passed-in object is a generic object.		 * @return <code>true</code> if the passed-in object is a generic object.		 */		public static function isGenericObject( o:* ):Boolean 
		{			return o["constructor"] == Object;		}    
		/**		 * Checks if the passed-in object is an instance of the passed-in type.		 * @return <code>true</code> if the passed-in object is an instance of the passed-in type.		 */		public static function isInstanceOf(o:*, type:*):Boolean 
		{			if (type === Function(Object)) return true;			return (o is type);		}
		/**		 * Checks if the passed-in object is a primitive type.		 * @return <code>true</code> if the passed-in object is a primitive type.		 */		public static function isPrimitive(o:*):Boolean 
		{			return (o is String || o is Number || o is Boolean);		}
		/**		 * Checks if the result of an execution of the typeof method on the passed-in object matches the passed-in type.		 * @return <code>true</code> if the result of an execution of the typeof method on the passed-in object matches the passed-in type.		 */		public static function isTypeOf(o:*, type:String):Boolean 
		{			return typeof(o) == type;		}
		/**		 * Check if the passed-in string is a Number.		 * @return <code>true</code> if the passed-in object is a Number.		 */		public static function isNumber(str:String):Boolean 
		{			return IS_NUMBER.test(str);		}
		/**		 * Check if the passed-in string is a Boolean.		 * @return <code>true</code> if the passed-in object is a Boolean.		 * @see sekati.converters.BoolConverter		 */		public static function isBoolean(str:String):Boolean 
		{			return IS_BOOLEAN.test(str);		}
		/**		 * Check if the passed-in string is an hexidecimal value.		 * @return <code>true</code> if the passed-in object is a hexidecimal value.		 */		public static function isHex(str:String):Boolean 
		{			return IS_HEX.test(str);		}
		/**		 * Check if the passed-in string is an octal value.		 * @return <code>true</code> if the passed-in object is a octal value.		 */		public static function isOctal(str:String):Boolean 
		{			return IS_OCTAL.test(str);		}
		/**		 * Checks if the type of the passed-in object matches the passed-in type.		 * <p><b>Usage:</b><br><code>		 * import sekati.validate.TypeValidation;		 * var s1:String = "hello world";		 * var s2:String = new String("hello world");		 * trace("s1 is string : " + TypeValidation.typesMatch( s1, String )); // output : 'true'		 * trace("s2 is string : " + TypeValidation.typesMatch( s2, String )); // output : 'true'		 * </code></p>		 */		public static function typesMatch(o:*, type:*):Boolean 
		{			return o is type;		}
		/**		 * TypeValidation Static Constructor		 */		public function TypeValidator() 
		{			throw new Error("TypeValidation is a static class and cannot be instantiated.");		}			}}