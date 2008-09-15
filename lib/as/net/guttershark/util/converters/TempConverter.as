package net.guttershark.util.converters {	/**	 * Temperature Conversion utilities	 */	final public class TempConverter 	{		/**		 * Convert Fahrenheit to Celsius		 * @param f (Number) fahrenheit value		 * @param p (Number) number of decimal after int '.' without round		 * @return Number		 */		public static function toCelsius(f:Number, p:Number = 2):Number 		{			var d:String;			var r:Number = (5 / 9) * (f - 32);			var s:Array = r.toString().split(".");			if (s[1] != undefined) 			{				d = s[1].substr(0,p);			}			else 			{				var i:Number = p;				while (i > 0) 				{					d += "0";					i--;				}			}			var c:String = s[0] + "." + d;			return Number(c);				}		/**		 * Convert Celsius to Fahrenheit		 * @param c (Number) celsius value		 * @param p (Number) number of decimal after int '.' without round		 * @return Number		 */		public static function toFahrenheit(c:Number, p:Number = 2):Number 		{			var d:String;			var r:Number = (c / (5 / 9)) + 32;			var s:Array = r.toString().split(".");			if (s[1] != undefined) 			{				d = s[1].substr(0,p);			} else 			{				var i:Number = p;				while (i > 0) 				{					d += "0";					i--;				}			}			var f:String = s[0] + "." + d;			return Number(f);				}			}}