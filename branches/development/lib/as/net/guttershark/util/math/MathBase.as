package net.guttershark.util.math{	/**	 * MathBase provides a common math API.	 */	public class MathBase 	{		/**		 * Returns the highest value of all passed arguments like <code>Math.max( )</code> 		 * but supports any number of args passed to it.		 */		public static function max(...args):Number 		{			return maxArray(args);		}		/**		 * Returns the lowest value of all passed arguments like <code>Math.min( )</code> 		 * but supports any number of args passed to it.		 */		public static function min(...args):Number 		{			return minArray(args);		}		/**		 * Returns the highest value of all items in array like <code>Math.max( )</code> 		 * but supports any number of items.		 */		public static function maxArray(a:Array):Number 		{			return Math.max.apply(MathBase,a);		}		/**		 * Returns the lowest value of all items in array like <code>Math.min()</code> 		 * but supports any number of items.		 */		public static function minArray(a:Array):Number 		{			return Math.min.apply(MathBase,a);		}		/**		 * Same as <code>Math.floor( )</code> with extra argument to specify number of decimals.		 */		public static function floor(val:Number, decimal:Number):Number 		{			var n:Number = Math.pow(10,decimal);			return Math.floor(val * n) / n;		}			/**		 * Round to a given amount of decimals.		 */		public static function round(val:Number, decimal:Number):Number 		{			return Math.round(val * Math.pow(10,decimal)) / Math.pow(10,decimal);		}		/**		 * Returns a random number inside a specific range.		 */			public static function random(start:Number, end:Number):Number 		{			return Math.round(Math.random() * (end - start)) + start;		}					/**		 * Constrain a value to the defined numeric boundaries. 		 * <i>Deprecated:</i> Use MathBase.clamp() instead. 		 * @see #clamp()		 */		public static function constrain(val:Number, min:Number, max:Number):Number 		{			if (val < min) 			{				val = min;			} else if (val > max) 			{				val = max;			}			return val;		}		/**		 * Clamp constrains a value to the defined numeric boundaries.		 * @example <listing version="3.0">		 * val: 20, 2 to 5    this will give back 5 since 5 is the top boundary		 * val: 3, 2 to 5     this will give back 3		 * </listing>		 */		public static function clamp( val:Number, min:Number, max:Number ):Number 		{			if( val < min ) return min;			if( val > max ) return max;			return val;		}		/**		 * Similar to clamp & constrain but allows for <i>limit value wrapping</i>.		 * @see #clamp()		 */		public static function limit(val:Number, min:Number, max:Number, wrap:Boolean = false):Number 		{			if(!wrap) 			{				return clamp(val,min,max);				}			while (val > max) val -= (max - min);			while (val < min) val += (max - min);			return val;		}				/**		 * Return the distance between two points.		 */		public static function distance( x1:Number, x2:Number, y1:Number, y2:Number ):Number 		{			var dx:Number = x1 - x2;			var dy:Number = y1 - y2;			return Math.sqrt(dx * dx + dy * dy);		}				/**		 * Return the proportional value of two pairs of numbers.		 */		public static function proportion(x1:Number, x2:Number, y1:Number, y2:Number, x:Number = 1):Number 		{			var n:Number = (!x) ? 1 : x;			var slope:Number = (y2 - y1) / (x2 - x1);			return (slope * (n - x1) + y1);		}		/**		 * Return a percentage based on the numerator and denominator.		 */		public static function percent(amount:Number, total:Number):Number 		{			if ( total == 0 ) 			{ 				return 0; 			}			return (amount / total * 100);		}		/**		 * Check if number is positive (zero is considered positive).		 */		public static function isPositive(n:Number):Boolean 		{			return (n >= 0);		}		/**		 * Check if number is negative.		 */		public static function isNegative(n:Number):Boolean 		{			return (n < 0);		}			/**		 * Check if number is Odd (convert to Integer if necessary).		 */		public static function isOdd(n:Number):Boolean 		{			var i:Number = new Number(n);			var e:Number = new Number(2);			return Boolean(i % e);			}		/**		 * Check if number is Even (convert to Integer if necessary).		 */		public static function isEven(n:Number):Boolean 		{			var int:Number = new Number(n);			var e:Number = new Number(2);			return (int % e == 0);		}		/**		 * Check if number is Prime (divisible only itself and one).		 */		public static function isPrime(n:Number):Boolean 		{			if (n > 2 && n % 2 == 0) return false;			var l:Number = Math.sqrt(n);			for (var i:Number = 3;i <= l; i += 2) 			{				if (n % i == 0) return false;			}			return true;		}		/**		 * Calculate the factorial of the integer.		 */		public static function factorial(n:Number):Number 		{			if (n == 0) return 1;			var d:Number = n.valueOf();			var i:Number = d - 1;			while (i) 			{				d = d * i;				i--;			}			return d;		}		/**		 * Return an array of divisors of the integer.		 */		public static function getDivisors(n:Number):Array 		{			var r:Array = new Array();			for (var i:Number = 1, e:Number = n / 2;i <= e; i++) 			{				if (n % i == 0) r.push(i);			}			if (n != 0) r.push(n.valueOf());			return r;		}		/**		 * Check if number is an Integer.		 */		public static function isInteger(n:Number):Boolean 		{			return (n % 1 == 0);		}		/**		 * Check if number is Natural (positive Integer).		 */		public static function isNatural(n:Number):Boolean 		{			return (n >= 0 && n % 1 == 0);		}		/**		 * Correct "roundoff errors" in floating point math.		 * @see http://www.zeuslabs.us/2007/01/30/flash-floating-point-number-errors/ 		 */		public static function sanitizeFloat(n:Number, precision:uint = 5):Number 		{			var c:Number = Math.pow(10,precision);			return Math.round(c * n) / c;		}		/**		 * Evaluate if two numbers are nearly equal.		 * @see http://www.zeuslabs.us/2007/01/30/flash-floating-point-number-errors/		 */		public static function fuzzyEval(n1:Number, n2:Number, precision:int = 5):Boolean 		{			var d:Number = n1 - n2;			var r:Number = Math.pow(10,-precision);			return d < r && d > -r;		}		/**		 * MathBase Static Constructor		 */		public function MathBase() 		{			throw new Error("MathBase is a static class and cannot be instantiated.");		}		}}