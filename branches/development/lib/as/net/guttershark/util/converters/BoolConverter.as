package net.guttershark.util.converters{	/**	 * Boolean Conversion utilities	 */	final public class BoolConverter 	{		/**		 * Convert string or number to boolean		 * @param s (*) boolean string ("1", "true", "yes", "on")		 * @return Boolean		 * @example		 * <listing version="3.0">			 * var b:Boolean = BoolConversion.toBoolean("true");		 * </listing>		 */		public static function toBoolean(s:*):Boolean 		{			var b:String = String(s).toLowerCase();			if(b == "1" || b == "true" || b == "yes" || b == "on") return true;			else if (b == "0" || b == "false" || b == "no" || b == "off") return false; 			else throw new Error("BoolConversion.toBoolean() could not convert input to a proper Boolean value");		}		/**		 * Convert boolean value to string		 * @param b (Boolean)		 * @return String		 * @example		 * <listing version="3.0">			 * var str:String = BoolConversion.toString(true);		 * </listing>		 */		public static function toString(b:Boolean):String 		{			var str:String = (b) ? "true" : "false";			return str;		}	}}