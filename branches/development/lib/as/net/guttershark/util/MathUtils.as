package net.guttershark.util
{
	import net.guttershark.util.Singleton;
	import net.guttershark.util.geom.Point;
	import net.guttershark.util.geom.Point3D;	

	/**
	 * The MathUtils class contains various math functions.
	 */
	final public class MathUtils
	{
		
		private static var inst:MathUtils;
		private var su:StringUtils;
		protected const BYTE:Number = 8;
		protected const KILOBIT:Number = 1024;
		protected const KILOBYTE:Number = 8192;
		protected const MEGABIT:Number = 1048576;
		protected const MEGABYTE:Number = 8388608;
		protected const GIGABIT:Number = 1073741824;
		protected const GIGABYTE:Number = 8589934592; 
		protected const TERABIT:Number = 1.099511628e+12;
		protected const TERABYTE:Number = 8.796093022e+12;
		protected const PETABIT:Number = 1.125899907e+15;
		protected const PETABYTE:Number = 9.007199255e+15;
		protected const EXABIT:Number = 1.152921505e+18;
		protected const EXABYTE:Number = 9.223372037e+18;
		
		/** 
		 * String for quick lookup of a hex character based on index
		 */
		public const HEX_CHARACTERS:String = "0123456789abcdef";
		
		/**
		 * Singleton access.
		 */
		public static function gi():MathUtils
		{
			if(!inst) Singleton.gi(MathUtils);
			return inst;
		}
		
		/**
		 * @private
		 * Constructor.
		 */
		public function MathUtils()
		{
			Singleton.assertSingle(MathUtils);
			su = StringUtils.gi();
		}
		
		/**
		 * Rotates <code>x</code> left <code>n</code> bits
		 */
		public function rol(x:int,n:int):int
		{
			return ( x << n ) | ( x >>> ( 32 - n ) );
		}
		
		/**
		 * Rotates <code>x</code> right <code>n</code> bits
		 */
		public function ror(x:int,n:int):uint
		{
			var nn:int = 32 - n;
			return ( x << nn ) | ( x >>> ( 32 - nn ) );
		}

		/**
		 * Outputs the hex value of a int, allowing the developer to specify
		 * the endinaness in the process. Hex output is lowercase.
		 *
		 * @param n The int value to output as hex
		 * @param bigEndian Flag to output the int as big or little endian
		 * @return A string of length 8 corresponding to the hex representation of n ( minus the leading "0x" )
		 */
		public function toHex( n:int, bigEndian:Boolean = false ):String 
		{
			var s:String = "";
			if(bigEndian) for(var i:int = 0;i < 4;i++) s += HEX_CHARACTERS.charAt(( n >> ( ( 3 - i ) * 8 + 4 ) ) & 0xF) + HEX_CHARACTERS.charAt(( n >> ( ( 3 - i ) * 8 ) ) & 0xF);
			else for(var x:int=0;x<4;x++) s += HEX_CHARACTERS.charAt(( n >> ( x * 8 + 4 ) ) & 0xF) + HEX_CHARACTERS.charAt(( n >> ( x * 8 ) ) & 0xF);			
			return s;
		}
		
		/**
		 * Returns the highest value of all passed arguments like <code>Math.max( )</code> 
		 * but supports any number of args passed to it.
		 */
		public function max(...args):Number 
		{
			return args.sort()[-1];
		}

		/**
		 * Returns the lowest value of all passed arguments like <code>Math.min( )</code> 
		 * but supports any number of args passed to it.
		 */
		public function min(...args):Number
		{
			return args.sort()[0];
		}
		
		/**
		 * Same as <code>Math.floor( )</code> with extra argument to specify number of decimals.
		 */
		public function floor(val:Number, decimal:Number):Number 
		{
			var n:Number = Math.pow(10,decimal);
			return Math.floor(val * n) / n;
		}	

		/**
		 * Round to a given amount of decimals.
		 */
		public function round(val:Number, decimal:Number):Number 
		{
			return Math.round(val * Math.pow(10,decimal)) / Math.pow(10,decimal);
		}

		/**
		 * Returns a random number inside a specific range.
		 */	
		public function random(start:Number, end:Number):Number 
		{
			return Math.round(Math.random() * (end - start)) + start;
		}

		/**
		 * Clamp constrains a value to the defined numeric boundaries.
		 * @example	
		 * <listing>	
		 * utils.math.clamp(20,2,5); //gives back 5.
		 * utils.math.clamp(3,2,5); //gives back 3.
		 * </listing>
		 */
		public function clamp( val:Number, min:Number, max:Number ):Number 
		{
			if(val < min) return min;
			if(val > max) return max;
			return val;
		}

		/**
		 * Similar to clamp & constrain but allows for <i>limit value wrapping</i>.
		 * @see #clamp()
		 */
		public function limit(val:Number, min:Number, max:Number, wrap:Boolean = false):Number 
		{
			if(!wrap) return clamp(val,min,max);
			while (val > max) val -= (max - min);
			while (val < min) val += (max - min);
			return val;
		}		

		/**
		 * Return the distance between two points.
		 */
		public function distance( x1:Number, x2:Number, y1:Number, y2:Number ):Number 
		{
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			return Math.sqrt(dx * dx + dy * dy);
		}		

		/**
		 * Return the proportional value of two pairs of numbers.
		 */
		public function proportion(x1:Number, x2:Number, y1:Number, y2:Number, x:Number = 1):Number 
		{
			var n:Number = (!x) ? 1 : x;
			var slope:Number = (y2 - y1) / (x2 - x1);
			return (slope * (n - x1) + y1);
		}

		/**
		 * Return a percentage based on the numerator and denominator.
		 */
		public function percent(amount:Number, total:Number):Number 
		{
			if(total == 0) return 0;
			return (amount / total * 100);
		}

		/**
		 * Check if number is positive (zero is considered positive).
		 */
		public function isPositive(n:Number):Boolean 
		{
			return (n >= 0);
		}

		/**
		 * Check if number is negative.
		 */
		public function isNegative(n:Number):Boolean 
		{
			return (n < 0);
		}	

		/**
		 * Check if number is Odd (convert to Integer if necessary).
		 */
		public function isOdd(n:Number):Boolean 
		{
			var i:Number = new Number(n);
			var e:Number = new Number(2);
			return Boolean(i % e);
		}

		/**
		 * Check if number is Even (convert to Integer if necessary).
		 */
		public function isEven(n:Number):Boolean 
		{
			var int:Number = new Number(n);
			var e:Number = new Number(2);
			return (int % e == 0);
		}

		/**
		 * Check if number is Prime (divisible only itself and one).
		 */
		public function isPrime(n:Number):Boolean 
		{
			if (n > 2 && n % 2 == 0) return false;
			var l:Number = Math.sqrt(n);
			for (var i:Number = 3;i <= l; i += 2) if(n % i == 0) return false;
			return true;
		}

		/**
		 * Calculate the factorial of the integer.
		 */
		public function factorial(n:Number):Number 
		{
			if (n == 0) return 1;
			var d:Number = n.valueOf();
			var i:Number = d - 1;
			while (i) 
			{
				d = d * i;
				i--;
			}
			return d;
		}

		/**
		 * Return an array of divisors of the integer.
		 */
		public function getDivisors(n:Number):Array 
		{
			var r:Array = new Array();
			for(var i:Number = 1, e:Number = n / 2;i <= e; i++) if (n % i == 0) r.push(i);
			if (n != 0) r.push(n.valueOf());
			return r;
		}

		/**
		 * Check if number is an Integer.
		 */
		public function isInteger(n:Number):Boolean 
		{
			return (n % 1 == 0);
		}

		/**
		 * Check if number is Natural (positive Integer).
		 */
		public function isNatural(n:Number):Boolean 
		{
			return (n >= 0 && n % 1 == 0);
		}

		/**
		 * Correct "roundoff errors" in floating point math.
		 * @see http://www.zeuslabs.us/2007/01/30/flash-floating-point-number-errors/ 
		 */
		public function sanitizeFloat(n:Number, precision:uint = 5):Number 
		{
			var c:Number = Math.pow(10,precision);
			return Math.round(c * n) / c;
		}

		/**
		 * Evaluate if two numbers are nearly equal.
		 * @see http://www.zeuslabs.us/2007/01/30/flash-floating-point-number-errors/
		 */
		public function fuzzyEval(n1:Number, n2:Number, precision:int = 5):Boolean
		{
			var d:Number = n1 - n2;
			var r:Number = Math.pow(10,-precision);
			return d < r && d > -r;
		}

		/**
		 * Returns a random float.
		 * @example
		 * <listing>	
		 * Random.float(50); //returns a number between 0-50 exclusive
		 * Random.float(20,50); //returns a number between 20-50 exclusive
		 * </listing>
		 */
		public function randFloat(min:Number,max:Number=NaN):Number 
		{
			if(isNaN(max)) 
			{ 
				max = min; 
				min = 0; 
			}
			return Math.random() * (max - min) + min;
		}

		/**
		 * Return a "tilted" random Boolean value.
		 * @param chance Percentage chance advantage of true.
		 * @example	
		 * <listing>	
		 * Random.boolean(); //returns 50% chance of true.
		 * Random.boolean(.75); //returns 75% chance of true.
		 * </listing>
		 */
		public function randBool(chance:Number = 0.5):Boolean
		{
			return (Math.random()<chance);
		}

		/**
		 * Return a "tilted" value of 1 or -1.
		 * @param chance Percentage chance advantage of true.
		 * @example
		 * <listing>	
		 * Random.sign(); //returns 50% chance of 1.
		 * Random.sign(.75); //returns 75% chance of 1.
		 * </listing>
		 */		
		public function sign(chance:Number=0.5):int 
		{
			return (Math.random()<chance)?1:-1;
		}

		/**
		 * Return a "tilted" value of 1 or 0.
		 * @param chance Percentage chance advantage of true.
		 * @example
		 * <listing>	
		 * Random.bit(); //returns 50% chance of 1.
		 * Random.bit(.75); //returns 75% chance of 1.
		 * </listing>
		 */
		public function randBit(chance:Number = 0.5):int
		{
			return (Math.random() < chance) ? 1 : 0;
		}

		/**
		 * Return a random integer.
		 * 
		 * @example
		 * <listing>	
		 * Random.integer(25); //returns an integer between 0-24 inclusive.
		 * Random.integer(10,25); //returns an integer between 10-24 inclusive.
		 * </listing>
		 * 
		 * @param chance Percentage chance advantage of true.
		 */
		public function randInteger(min:Number,max:Number=NaN):int 
		{
			if(isNaN(max)) 
			{ 
				max = min; 
				min = 0; 
			}
			// Need to use floor instead of bit shift to work properly with negative values:
			return Math.floor(randFloat(min,max));
		}
		
		
		/**
		 * Check if a number is in range.
		 */
		public function isInRange(n:Number, min:Number, max:Number, blacklist:Array = null):Boolean 
		{
			if(!blacklist) blacklist = new Array();	
			if(blacklist.length > 0) 
			{
				for(var i:String in blacklist) if(n == blacklist[i]) return false;
			}
			return (n >= min && n <= max);
		}	

		/**
		 * Returns a set of random numbers inside a specific range (unique numbers is optional)
		 */
		public function randRangeSet(min:Number, max:Number, count:Number, unique:Boolean):Array 
		{
			var rnds:Array = new Array();
			if (unique && count <= max - min + 1) 
			{
				//unique - create num range array
				var nums:Array = new Array();
				for (var i:Number = min;i <= max; i++) 
				{
					nums.push(i);
				}
				for (var j:Number = 1;j <= count; j++) 
				{
					// random number
					var rn:Number = Math.floor(Math.random() * nums.length);
					rnds.push(nums[rn]);
					nums.splice(rn,1);
				}
			} else 
			{
				//non unique
				for (var k:Number = 1;k <= count; k++) 
				{
					rnds.push(randRangeInt(min,max));
				}
			}
			return rnds;
		}

		/**
		 * Returns a random float number within a given range
		 */
		public function randRangeFloat(min:Number, max:Number):Number 
		{
			return Math.random() * (max - min) + min;
		}

		/**
		 * Returns a random int number within a given range
		 */
		public function randRangeInt(min:Number, max:Number):Number 
		{
			return Math.floor(Math.random() * (max - min + 1) + min);
		}		

		/**
		 * Resolve the number inside the range. If outside the range the nearest boundary value will be returned.
		 */
		public function resolve(val:Number, min:Number, max:Number):Number
		{
			return Math.max(Math.min(val,max),min);	
		}

		/**
		 * Locate and return the middle value between the three.
		 */
		public function center(a:Number, b:Number, c:Number):Number 
		{
			if((a > b) && (a > c))
			{
				if (b > c) return b; 
				else return c;
			}
			else if ((b > a) && (b > c)) 
			{
				if (a > c) return a;
				else return c;
			}
			else if (a > b) return a;
			else return b;
		}
		
		/**
		 * Convert angle to radian
		 */
		public function angle2radian(a:Number):Number
		{
			return resolveAngle(a) * Math.PI / 180;
		}

		/**
		 * Convert radian to angle
		 */
		public function radian2angle(r:Number):Number 
		{
			return resolveAngle(r * 180 / Math.PI);
		}

		/**
		 * will always give back a positive angle between 0 and 360
		 */
		public function resolveAngle(a:Number):Number 
		{
			var mod:Number = a % 360;
			return (mod < 0) ? 360 + mod : mod;
		}

		/**
		 * Get angle from two points
		 */
		public function getAngle(p1:Point, p2:Point):Number 
		{
			var r:Number = Math.atan2(p2.y - p1.y,p2.x - p1.x);
			return radian2angle(r);
		}

		/**
		 * Get radian from two points
		 */
		public function getRadian(p1:Point, p2:Point):Number 
		{
			return angle2radian(getAngle(p1,p2));
		}

		/**
		 * Get distance between two points
		 */
		public function getDistance(p1:Point, p2:Point):Number 
		{
			var xd:Number = p1.x - p2.x;
			var yd:Number = p1.y - p2.y;
			return Math.sqrt(xd * xd + yd * yd);
		}
		
		/**
		 * Get z distance between two Point3D instances.
		 */
		public function getZDistance(p1:Point3D, p2:Point3D):Number 
		{
			return  p1.z - p2.z;
		}

		/**
		 * Get new point based on distance and angle from a given point.
		 * 
		 * Note: Rounding to 3 decimals because got results like this: 6.12303176911189e-15
		 * just as a precaution not to screw up movieclips positions & infinite tween loops
		 */
		public function getPointFromDistanceAndAngle(centerPoint:Point, dist:Number, angle:Number):Point 
		{
			var rad:Number = angle2radian(angle);
			return new Point(round(centerPoint.x + Math.cos(rad) * dist,3),round(centerPoint.y + Math.sin(rad) * dist,3));
		}
		
		/**
		 * Convert an integer to binary string representation.
		 * 
		 * @param numberToConvert The integer to convert.
		 */
		public function toBinary(numberToConvert:int):String
		{
			var result:String = "";
			for(var i:Number = 0;i < 32; i++)
			{
				var lsb:int = numberToConvert & 1;
				result = (lsb?"1":"0") + result;
				numberToConvert >>= 1;
			}
			return result;
		}
		
		/**
		 * Convert a binary string (000001010) to an integer.
		 * 
		 * @param binaryString The string to convert.
		 */
		public function toDecimal(binaryString:String):int 
		{
			var result:Number = 0;
			for(var i:int = binaryString.length;i > 0; i--) result += parseInt(binaryString.charAt(binaryString.length - i)) * Math.pow(2,i - 1);
			return result;
		}
		
		/**
		 * Convert Fahrenheit to Celsius
		 * 
		 * @param f Fahrenheit value
		 * @param p The number of decimal after int '.' without round.
		 */
		public function toCelsius(f:Number, p:Number = 2):Number 
		{
			var d:String;
			var r:Number = (5 / 9) * (f - 32);
			var s:Array = r.toString().split(".");
			if (s[1] != undefined) d = s[1].substr(0,p);
			else 
			{
				var i:Number = p;
				while (i > 0) 
				{
					d += "0";
					i--;
				}
			}
			var c:String = s[0] + "." + d;
			return Number(c);		
		}

		/**
		 * Convert Celsius to Fahrenheit.
		 * 
		 * @param c Celsius value.
		 * @param p The number of decimal after int '.' without round.
		 */
		public function toFahrenheit(c:Number, p:Number = 2):Number 
		{
			var d:String;
			var r:Number = (c / (5 / 9)) + 32;
			var s:Array = r.toString().split(".");
			if (s[1] != undefined) d = s[1].substr(0,p);
			else 
			{
				var i:Number = p;
				while (i > 0) 
				{
					d += "0";
					i--;
				}
			}
			var f:String = s[0] + "." + d;
			return Number(f);		
		}
		
		/**
		 * Convert XML data to native types.
		 * 
		 * @param value The string value from XML.
		 */
		public function parseXMLAsType(value:String):*
		{
			var v:String = value.toLowerCase();
			if(!isNaN(Number(value))) return Number(value);
			if(v == "true" || v == "false" || v == "0" || v == "1" || v == "yes" || v == "no" || v == "on" || v == "off") return su.toBoolean(value);
			if(v == "null") return null;
			return value;
		}
		
		public function byte2bit(n:Number):Number
		{
			return n * BYTE;
		}

		public function kilobit2bit(n:Number):Number 
		{
			return n * KILOBIT;
		}

		public function kilobyte2bit(n:Number):Number 
		{
			return n * KILOBYTE;	
		}

		public function megabit2bit(n:Number):Number 
		{
			return n * MEGABIT;
		}

		public function megabyte2bit(n:Number):Number 
		{
			return n * MEGABYTE;
		}			

		public function gigabit2bit(n:Number):Number 
		{
			return n * GIGABIT;
		}

		public function gigabyte2bit(n:Number):Number
		{
			return n * GIGABYTE;
		}

		public function terabit2bit(n:Number):Number 
		{
			return n * TERABIT;	
		}

		public function terabyte2bit(n:Number):Number 
		{
			return n * TERABYTE;
		}

		public function petaabit2bit(n:Number):Number 
		{
			return n * PETABIT;	
		}

		public function petabyte2bit(n:Number):Number 
		{
			return n * PETABYTE;
		}

		public function exabit2bit(n:Number):Number 
		{
			return n * EXABIT;	
		}

		public function exabyte2bit(n:Number):Number 
		{
			return n * EXABYTE;
		}	}}