package net.guttershark.util.types
{
	import net.guttershark.util.Singleton;	
	
	/**
	 * The ArrayUtils class contains utility methods for arrays.
	 */
	final public class ArrayUtils 
	{

		/**
		 * Singleton instance.
		 */
		private static var inst:ArrayUtils;
		
		/**
		 * Singleton access.
		 */
		public static function gi():ArrayUtils
		{
			if(!inst) inst = Singleton.gi(ArrayUtils);
			return inst;
		}
		
		/**
		 * @private
		 */
		public function ArrayUtils()
		{
			Singleton.assertSingle(ArrayUtils);
		}

		public function search():void
		{
			var a:int = 0;
		}

		public static function Search():void
		{
			var a:int = 0;
		}

		/**
		 * Clones an array.
		 * 
		 * @param array The array to clone.
		 */
		public function clone(array:Array):Array
		{
			//fast! - http://agit8.turbulent.ca/bwp/2008/08/04/flash-as3-optimization-fastest-way-to-copy-an-array/
			if(!array) throw new ArgumentError("The array cannot be null");
			return array.concat();
		}

		/**
		 * Insert an element into an array at a specific index.
		 * 
		 * @param a The array to insert an element into.
		 * @param element The object to insert.
		 * @param index The index the object will be inserted into.
		 */
		public function insert(a:Array, element:Object, index:int):Array 
		{
			var aA:Array = a.slice(0,index - 1);
			var aB:Array = a.slice(index,a.length - 1);
			aA.push(element);
			return merge(aA,aB);
		}

		/**
		 * Remove all instances of an element from an array.
		 * 
		 * @param a The array to search and remove from.
		 * @param element The element to remove from the array.
		 */
		public function remove(a:Array, element:Object):Array 
		{
			for(var i:int = 0;i < a.length; i++) if(a[i]===element) a.splice(i,1);
			return a;
		}

		/**
		 * Determines if a value exists within the array.
		 * 
		 * @param a The array to search.
		 * @param val The element to search for.
		 */			
		public function contains(a:Array, element:Object):Boolean 
		{
			return(a.indexOf(element) != -1);
		}

		/**
		 *
		 * Search an array for a given element and return its index or <code>-1</code>.
		 * 
		 * @param a The array to search.
		 * @param element The element to search for.
		 *
		public static function search(a:Array, element:Object):int 
		{
			for(var i:int = 0;i < a.length; i++) if(a[i]===element) return i;
			return -1;
		}*/

		/**
		 * Shuffle array elements.
		 * 
		 * @param a The array to shuffle.
		 */
		public function shuffle(a:Array):void 
		{
			var l:int = a.length;
			var i:int = 0;
			for(i;i<l;i++) 
			{
				var tmp:* = a[i];
				var rand:int = int(Math.random()*l);
				a[i] = a[rand];
				a[rand] = tmp;
			}
		}

		/**
		 * Create a new array that only contains unique instances of objects in the specified array.
		 * this can be used to remove duplication object instances from an array.
		 * 
		 * @param a The array to uniquely copy.
		 */
		public function uniqueCopy(a:Array):Array 
		{
			var newArray:Array = new Array();
			var len:int = a.length;
			var item:Object;
			var i:int = 0;
			for(i;i<len;++i) 
			{
				item = a[i];
				if(contains(newArray,item)) continue;
				newArray.push(item);
			}
			return newArray;
		}
		
		/**
		 * Determine if one array is identical to the other array.
		 * 
		 * @param arr1 The first array.
		 * @param arr2 The second array.
		 */
		public function equals(arr1:Array, arr2:Array):Boolean 
		{
			if(arr1.length!=arr2.length) return false;
			var len:int = arr1.length;
			for(var i:int = 0;i < len; i++) if(arr1[i] !== arr2[i]) return false;
			return true;
		}

		/**
		 * Merge two arrays into one.
		 * 
		 * @param a The first array.
		 * @param b The second array. 
		 */
		public function merge(a:Array, b:Array):Array 
		{
			var c:Array = clone(b);
			for(var i:int = a.length - 1;i > -1; i--) c.unshift(a[i]);
			return c;
		}	

		/**
		 * Swap two element's positions in an array.
		 * 
		 * @param a The target array in which the swap will occur.
		 * @param index1 The first index.
		 * @param index2 The second index.
		 */
		public function swap(a:Array, index1:int, index2:int):Array
		{
			if(index1>=a.length||index1<0) 
			{
				throw new Error("Index A {"+index1+"} is not a valid index in the array.");
				return a;
			}
			if(index2>=a.length||index2<0) 
			{
				throw new Error("Index B {"+index2+"} is not a valid index in the array.");
				return a;
			}
			var el:Object = a[index1];
			a[index1] = a[index2];
			a[index2] = el;
			return a;
		}	
		
		/**
		 * Remove duplicates from an array and return a new array.
		 * 
		 * @param a The array to remove duplicates from.
		 */
		public function removeDuplicate(a:Array):Array 
		{
			a.sort();
			var o:Array = new Array();
			for(var i:int = 0;i < a.length; i++) if(a[i] != a[i + 1]) o.push(a[i]);
			return o;
		}

		/**
		 * Compares two arrays to see if any two indexes have the same
		 * value as the other array.
		 * 
		 * @param a The first array.
		 * @param b The second array.
		 */	
		public function matchValues(a:Array, b:Array):Boolean 
		{
			var f:int = 0;
			var l:int = 0;
			var al:int = a.length;
			var bl:int = b.length;
			for(f;f<al;f++) for(l;l<bl;l++) if(b[l].toLowerCase() === a[f].toLowerCase()) return true;
			return false;
		}

		/**
		 * Compare two arrays to see if their values (and optionally order) are identical.
		 * 
		 * @param ordered Whether or not the arrays will be sorted before the compare is performed.
		 * 
		 * @example Using ArrayUtils.compare:
		 * <listing>	
		 * var a:Array = [5,4,3,2,1,'C','B','A'];
		 * var b:Array = ['A','B','C',1,2,3,4,5];
		 * trace("arrays (unordered) compare: " + ArrayUtil.compare(a,b)); //true
		 * trace("arrays (ordered) compare: " + ArrayUtil.compare(a,b,true)); //false
		 * </listing>
		 */
		public function compare(a:Array, b:Array, ordered:Boolean = false):Boolean
		{
			var c:Array = (ordered) ? a : a.concat().sort(Array.DESCENDING);
			var d:Array = (ordered) ? b : b.concat().sort(Array.DESCENDING);
			if(c.length != d.length) return false;
			var l:int = c.length;
			var i:int = 0;
			for(i;i<l;i++) if(c[i]!==d[i]) return false;
			return true;
		}

		/**
		 * Search for a unique property/value match in an array of complex objects.
		 * 
		 * @param a An array of objects.
		 * @param prop The object property who's value will be tested.
		 * @param val The value to match.
		 * @param caseInsensitive Whether or not <em><code>prop</code></em> and <code>val</code> should be case-insensitive (only if search <em><code>val</code></em> is a <code>String</code>).
		 */
		public function locatePropVal(a:Array, prop:String, val:Object, caseInsensitive:Boolean = false):Object 
		{
			for(var o:String in a)
			{
				if(!caseInsensitive) if(a[o][prop] == val) return a[o];
				else if (a[o][prop].toUpperCase() == String(val).toUpperCase()) return a[o];
			}
			return null;
		}	

		/**
		 * Search for a unique property/value match in an array of
		 * complex objects and return its index in the array.
		 * 
		 * @param a An array of objects.
		 * @param prop The object property who's value will be tested.
		 * @param val The value to match.
		 * @param caseInsensitive Whether or not <em><code>prop</code></em> and <code>val</code> should be case-insensitive (only if search <em><code>val</code></em> is a <code>String</code>).
		 */
		public function locatePropValIndex(a:Array, prop:String, val:Object, caseInsensitive:Boolean = false):int 
		{
			for(var i:int = 0;i < a.length; i++)
			{
				if(!caseInsensitive) if(a[i][prop]==val)return i;
				else if (a[i][prop].toUpperCase()==String(val).toUpperCase())return i;
			}
			return -1;
		}

		/**
		 * Return a new array sliced from the original array of complex objects
		 * based on a <code>prop</code>/<code>val</code> match
		 * 
		 * @param a An array of objects.
		 * @param prop The object property who's value will be tested.
		 * @param val The value to match.
		 * @param caseInsensitive Whether or not <em><code>prop</code></em> and <code>val</code> should be case-insensitive (only if search <em><code>val</code></em> is a <code>String</code>).
		 */
		public function sliceByPropVal(a:Array, prop:String, val:Object, caseInsensitive:Boolean = false):Array 
		{
			var ma:Array = new Array();
			for(var o :String in a) 
			{
				if(!caseInsensitive) if(a[o][prop]==val) ma.push(a[o]); 
				else if(a[o][prop].toUpperCase()==String(val).toUpperCase()) ma.push(a[o]);
			}
			return ma;
		}	

		/**
		 * Locate and return the (lowest) nearest neighbor or matching value in a <code>NUMERIC</code> sorted array of Numbers.
		 * 
		 * @param val 				the value to find match or find nearst match of.
		 * @param range 			of values in array.
		 * @param returnIndex 		if <code>true</code> return the array index of the neighbor, if <code>false</code> return the value of the neighbor.
		 * 
		 * @example Using ArrayUtils.nearestNeighbor:
		 * <listing>
		 * var a:Array = [1, 3, 5, 7, 9, 11];
		 * var nearestLow:Number = ArrayUtil.nearestNeighbor(4,a); //returns 3 (value)
		 * var nearestHigh:Number = ArrayUtil.nearestNeighbor(4,a,true); //returns 1 (index)
		 * </listing>
		 */
		public function nearestNeighbor(val:Number,range:Array,returnIndex:Boolean = false):Number
		{
			var nearest:Number = range[0];
			var index:uint = 0;
			for(var i:int = 1;i < range.length; i++) 
			{
				if(Math.abs(range[i] - val) < Math.abs(nearest - val))
				{
					nearest = range[i];
					index = i;
				}
			}
			return (!returnIndex) ? nearest : index;
		}

		/**
		 * Return the array index of the minimum value in a numeric array.
		 * 
		 * @param a The array to search.
		 */
		public function minIndex(a:Array):int 
		{
			var i:int = a.length;
			var min:Number = a[0];
			var idx:int = 0;
			while (i-- > 1) if(a[i] < min) min = a[idx = i];
			return idx;
		}

		/**
		 * Return the array index of the maximum value in a numeric array.
		 * 
		 * @param a The array to search.
		 */	
		public function maxIndex(a:Array):int 
		{
			var i:int = a.length;
			var max:Number = a[0];
			var idx:int = 0;
			while(i-- > 1) if(a[i] > max) max = a[idx = i];
			return idx;	
		}

		/**
		 * Return the minimum value in a numeric array.
		 * 
		 * @param a The array to search.
		 */	
		public function minValue(a:Array):Number 
		{
			if(a.length==0) return 0;
			return a[minIndex(a)];
		}

		/**
		 * Return the maximum value in a numeric array.
		 * 
		 * @param a The array to search.
		 */	
		public function maxVal(a:Array):Number
		{
			if(a.length==0) return 0;
			return a[maxIndex(a)];
		}
	}
}