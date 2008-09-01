package net.guttershark.util.converters{
	/**	 * Binary conversion utilities	 */	public class BinaryConverter 
	{
		/**		 * Convert int to binary string representation		 */		public static function toBinary(numberToConvert:int):String 
		{			var result:String = "";			for ( var i:Number = 0;i < 32; i++) 
			{				// Extract least significant bit using bitwise AND				var lsb:int = numberToConvert & 1;				// Add this bit to the result				result = (lsb ? "1" : "0") + result;               				// Shift numberToConvert right by one bit, to see next bit				numberToConvert >>= 1;			}			return result;		}
		/**		 * Convert binary string to int		 */		public static function toDecimal(binaryRepresentation:String):int 
		{			var result:Number = 0;			for (var i:int = binaryRepresentation.length;i > 0; i--) 
			{				result += parseInt(binaryRepresentation.charAt(binaryRepresentation.length - i)) * Math.pow(2,i - 1);			}              			return result;		}	}}