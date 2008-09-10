package net.guttershark.util.math{	/**	 * IntBase provides a common Integer API.	 */	public class IntBase 	{		/** 		 * String for quick lookup of a hex character based on index		 */		public static const HEX_CHARACTERS:String = "0123456789abcdef";				public static function compare(alpha:int, beta:int):int 		{			if(alpha < beta) return -1;			if(alpha > beta) return 1;			return 0;		}		public static function lessThan(alpha:int, beta:int):Boolean 		{			return compare(alpha,beta) == -1;		}		public static function greaterThan(alpha:int, beta:int):Boolean 		{			return compare(alpha,beta) == 1;		}				public static function equalTo(alpha:int, beta:int):Boolean 		{			return compare(alpha,beta) == 0;		}		/**		 * Rotates <code>x</code> left <code>n</code> bits		 */		public static function rol(x:int,n:int):int 		{			return ( x << n ) | ( x >>> ( 32 - n ) );		}		/**		 * Rotates <code>x</code> right <code>n</code> bits		 */		public static function ror(x:int,n:int):uint		{			var nn:int = 32 - n;			return ( x << nn ) | ( x >>> ( 32 - nn ) );		}		/**		 * Outputs the hex value of a int, allowing the developer to specify		 * the endinaness in the process.  Hex output is lowercase.		 *		 * @param n The int value to output as hex		 * @param bigEndian Flag to output the int as big or little endian		 * @return A string of length 8 corresponding to the hex representation of n ( minus the leading "0x" )		 */		public static function toHex( n:int, bigEndian:Boolean = false ):String 		{			var s:String = "";			if(bigEndian) for(var i:int = 0;i < 4;i++) s += HEX_CHARACTERS.charAt(( n >> ( ( 3 - i ) * 8 + 4 ) ) & 0xF) + HEX_CHARACTERS.charAt(( n >> ( ( 3 - i ) * 8 ) ) & 0xF);			else for(var x:int=0;x<4;x++) s += HEX_CHARACTERS.charAt(( n >> ( x * 8 + 4 ) ) & 0xF) + HEX_CHARACTERS.charAt(( n >> ( x * 8 ) ) & 0xF);						return s;		}		}}