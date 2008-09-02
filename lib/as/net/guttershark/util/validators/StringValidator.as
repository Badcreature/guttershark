package net.guttershark.util.validators 
{	import net.guttershark.util.StringUtils;
	/**	 * String Validation methods for form fields	 * @see sekati.utils.StringUtils	 */	public class StringValidator 
	{
		/**		 * Validate a string as a valid email address.		 */		public static function isValidEmail(str:String):Boolean 
		{			var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;			return !emailExpression.test(str);		}
		
		/**		 * Validate a string as a phone number.		 */		public static  function validatePhone(str:String):Boolean
		{			var phoneExpression:RegExp = /^((\+\d{1,3}(-| )?\(?\d\)?(-| )?\d{1,3})|(\(?\d{2,3}\)?))(-| )?(\d{3,4})(-| )?(\d{4})(( x| ext)\d{1,5}){0,1}$/i;			return !phoneExpression.test(str);		}		
		
		/**		 * Validate as "http://" or "https://".		 */		public static function isURL(str:String):Boolean 
		{			return (str.substring(0,7) == "http://" || str.substring(0,8) == "https://");		}	
			
		/**		 * Validate if a strings contents are blank after a safety trim is performed.		 */		public static function isBlank(s:String):Boolean 
		{			var str:String = StringUtils.trim(s);			var i:int = 0;			if (str.length == 0) 
			{				return true;			}			while (i < str.length) 
			{				if (str.charCodeAt(0) != 32) 
				{					return false;				}				i++;			}			return true;		}
		
		/**		 * Validate if a string is composed entirely of numbers.		 */		public static function isNumeric(str:String):Boolean 
		{			if (str == null) 
			{ 				return false; 			}			var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;			return regx.test(str);
		}
		
		/**		 * Check if address is a Post Office Box		 */		public static function isPOBox(address:String):Boolean
		{			var look:Array = ["PO ", "P O", "P.O", "P. O",  "p o", "p.o", "p. o", "Box", "Post Office", "post office"];			var len:Number = look.length;			for (var i:int = 0;i < len; i++) 
			{				if (address.indexOf(look[i]) != -1) 
				{					return true;				}			}			return false;		}		}}