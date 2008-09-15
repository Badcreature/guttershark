package net.guttershark.util.math{	/**	 * Range provides a common Numeric Range API.	 */	public class Range 	{		/**		 * Check if a number is in range.		 */		public static function isInRange(n:Number, min:Number, max:Number, blacklist:Array = null):Boolean 		{			if(!blacklist) blacklist = new Array();				if(blacklist.length > 0) 			{				for(var i:String in blacklist) if(n == blacklist[i]) return false;			}			return (n >= min && n <= max);		}			/**		 * Returns a set of random numbers inside a specific range (unique numbers is optional)		 */		public static function randRangeSet(min:Number, max:Number, count:Number, unique:Boolean):Array 		{			var rnds:Array = new Array();			if (unique && count <= max - min + 1) 			{				//unique - create num range array				var nums:Array = new Array();				for (var i:Number = min;i <= max; i++) 				{					nums.push(i);				}				for (var j:Number = 1;j <= count; j++) 				{					// random number					var rn:Number = Math.floor(Math.random() * nums.length);					rnds.push(nums[rn]);					nums.splice(rn,1);				}			} else 			{				//non unique				for (var k:Number = 1;k <= count; k++) 				{					rnds.push(randRangeInt(min,max));				}			}			return rnds;		}		/**		 * Returns a random float number within a given range		 */		public static function randRangeFloat(min:Number, max:Number):Number 		{			return Math.random() * (max - min) + min;		}		/**		 * Returns a random int number within a given range		 */		public static function randRangeInt(min:Number, max:Number):Number 		{			return Math.floor(Math.random() * (max - min + 1) + min);		}				/**		 * Resolve the number inside the range. If outside the range the nearest boundary value will be returned.		 */		public static function resolve(val:Number, min:Number, max:Number):Number		{			return Math.max(Math.min(val,max),min);			}		/**		 * Locate and return the middle value between the three.		 */		public static function center(a:Number, b:Number, c:Number):Number 		{			if((a > b) && (a > c))			{				if (b > c) return b; 				else return c;			}			else if ((b > a) && (b > c)) 			{				if (a > c) return a;				else return c;			}			else if (a > b) 			{				return a;			}			else 			{				return b;			}		}		}}