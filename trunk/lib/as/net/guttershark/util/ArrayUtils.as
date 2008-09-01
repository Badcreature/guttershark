package net.guttershark.util 
{
	
	/**
	 * The ArrayUtils class contains utility methods for arrays.
	 */
	public class ArrayUtils 
	{
		
		/**
		 * Clones an array.
		 * @param	array	The array to clone.
		 * @return	The cloned array.
		 */
		public static function Clone(array:Array):Array
		{
			Assert.NotNull(array, "The array cannot be null");
			return array.concat();
		}
		
		/**
		 * Shuffles an array.
		 * @param	array	The array to shuffle.
		 */
		public static function Shuffle(array:Array):void
		{
			Assert.NotNull(array, "The array cannot be null");
			var len:Number = array.length; 
	   		var rand:Number;
	   		var temp:*;
	   		for(var i:int = 0; i < len; i++)
	   		{ 
	   			rand = Math.floor(Math.random()*len); 
	   			temp = array[i]; 
	   			array[i] = array[rand]; 
	   			array[rand] = temp;
	   		}
		}
		
		/**
		 * Insert an element into array at a specific index.
		 */
		public static function insert(a : Array, objElement : Object, nIndex : int) : Array {
			var aA : Array = a.slice( 0, nIndex - 1 );
			var aB : Array = a.slice( nIndex, a.length - 1 );
			aA.push( objElement );
			return ArrayUtils.merge( aA, aB );
		}

		/**
		 * Remove all instances of an element from an array.
		 */
		public static function remove(a : Array, objElement : Object) : Array {
			for(var i : int = 0; i < a.length ; i++) {
				if (a[i] === objElement) {
					a.splice( i, 1 );
				}
			}
			return a;
		}

		/**
		 * 	Determines if a value exists within the array.
		 */			
		public static function contains(a : Array, val : Object) : Boolean {
			return (a.indexOf( val ) != -1);
		}	

		/**
		 * Search an array for a given element and return its index or <code>NaN</code>.
		 */	
		public static function search(a : Array, objElement : Object) : int {
			for (var i : int = 0; i < a.length ; i++) {
				if (a[i] === objElement) {
					return i;
				}
			}
			return NaN;
		}

		/**
		 * Shuffle array items.
		 */
		public static function shuffle(a : Array) : void {
			for (var i : int = 0; i < a.length ; i++) {
				var tmp : * = a[i];
				var rand : int = int( Math.random( ) * a.length );
				a[i] = a[rand];
				a[rand] = tmp;
			}
		}

		/**
		 * Create a new array that only contains unique instances of objects in the specified array.
		 * this can be used to remove duplication object instances from an array.
		 */
		public static function uniqueCopy(a : Array) : Array {
			var newArray : Array = new Array( );
			var len : int = a.length;
			var item : Object;
			for (var i : int = 0; i < len ; ++i) {
				item = a[i];
				if(contains( newArray, item )) {
					continue;
				}
				newArray.push( item );
			}
			return newArray;
		}

		/**
		 * Create a non-unique copy of the array.
		 * @param a 		array to clone.
		 * @return Array 	new array with items that are references to the original array.
		 */
		public static function copy(a : Array) : Array {	
			return a.slice( );
		}

		public static function equals(arr1 : Array, arr2 : Array) : Boolean {
			if(arr1.length != arr2.length) {
				return false;
			}
			var len : int = arr1.length;
			for(var i : int = 0; i < len ; i++) {
				if(arr1[i] !== arr2[i]) {
					return false;
				}
			}
			return true;
		}

		/**
		 * Merge two arrays into one.
		 */
		public static function merge(aA : Array, aB : Array) : Array {
			var aC : Array = ArrayUtils.copy( aB );
			for(var i : int = aA.length - 1; i > -1 ; i--) {
				aC.unshift( aA[i] );
			}
			return aC;
		}	

		/**
		 * Swap two elements positions in an array
		 * @throws Error on invalid array index
		 */
		public static function swap(a : Array, nA : int, nB : int) : Array {
			if (nA >= a.length || nA < 0) {
				throw new Error( "@@@ sekati.utils.ArrayUtils.swap() Error: Index 'A' (" + nA + ") is not a valid index in the array '" + a.toString( ) + "'." );
				return a;
			}
			if(nB >= a.length || nB < 0) {
				throw new Error( "@@@ sekati.utils.ArrayUtils.swap() Error: Index 'A' (" + nB + ") is not a valid index in the array '" + a.toString( ) + "'." );
				return a;
			}
			var objElement : Object = a[nA];
			a[nA] = a[nB];
			a[nB] = objElement;
			return a;
		}	

		/**
		 * Return alphabetically sorted array.
		 */
		public static function asort(a : Array) : Array {
			var aFn : Function = function (element1 : String, element2 : String):Boolean {
				return element1.toUpperCase( ) > element2.toUpperCase( );
			};
			return a.sort( aFn );
		}

		/**
		 * Return array with duplicate entries removed.
		 */
		public static function removeDuplicate(a : Array) : Array {
			a.sort( );
			var o : Array = new Array( );
			for (var i : int = 0; i < a.length ; i++) {
				if (a[i] != a[i + 1]) {
					o.push( a[i] );
				}
			}
			return o;
		}

		/**
		 * Compare two arrays for a matching value.
		 */	
		public static function matchValues(aA : Array, aB : Array) : Boolean {
			for (var f : int = 0; f < aA.length ; f++) {
				for (var l : int = 0; l < aB.length ; l++) {
					if (aB[l].toLowerCase( ) === aA[f].toLowerCase( )) {
						return true;
					}
				}
			}
			return false;
		}

		/**
		 * Compare two arrays to see if their values (and optionally order) are identical.
		 * @param hasSameOrder 	When <code>false</code> the arrays must only contain identical values, when <code>true</code> value & order must be identical.
		 * @example <listing version="3.0">
		 * 	var a : Array = [ 5,4,3,2,1,'C','B','A' ];
		 * 	var b : Array = [ 'A','B','C',1,2,3,4,5 ];
		 * 	trace( "arrays (unordered) compare: " + ArrayUtil.compare( a, b ) ); 		// returns true
		 * 	trace( "arrays (ordered) compare: " + ArrayUtil.compare( a, b, true ) );	// returns false
		 * </listing>
		 */
		public static function compare(aA : Array, aB : Array, hasSameOrder : Boolean = false) : Boolean {
			var a : Array = (hasSameOrder) ? aA : aA.slice( ).sort( Array.DESCENDING );
			var b : Array = (hasSameOrder) ? aB : aB.slice( ).sort( Array.DESCENDING );
			if(a.length != b.length) {
				return false;
			}
			var len : int = a.length;
			for(var i : int = 0; i < len ; i++) {
				if(a[i] !== b[i]) {
					return false;
				}
			}
			return true;
		}

		/**
		 * Search for a unique property/value match in an array of complex objects.
		 * @param a 					array of objects.
		 * @param prop 					array object property to locate.
		 * @param val 					array object property value to match.
		 * @param isCaseInsensitive 	define whether <code>prop</code>/<code>val</code> should be case-insensitive (use only if search <code>val</code> is <code>String</code>).
		 * @return Object 				the first array object with the <code>prop</code>/<code>val</code> match.
		 */
		public static function locatePropVal(a : Array, prop : String, val : Object, isCaseInsensitive : Boolean = false) : Object {
			for(var o :String in a) {
				if (!isCaseInsensitive) {
					if (a[o][prop] == val) return a[o];
				} else {
					if (a[o][prop].toUpperCase( ) == String( val ).toUpperCase( )) return a[o];	
				}		
			}
			return null;
		}	

		/**
		 * Search for a unique property/value match in an array of complex objects and return its index in the array.
		 * @param a 					array of objects.
		 * @param prop 					array object property to locate.
		 * @param val 					array object property value to match.
		 * @param isCaseInsensitive 	define whether <code>prop</code>/<code>val</code> should be case-insensitive (use only if search <code>val</code> is <code>String</code>).
		 * @return uint 				the index of the first array object with the <code>prop</code>/<code>val</code> match.
		 */
		public static function locatePropValIndex(a : Array, prop : String, val : Object, isCaseInsensitive : Boolean = false) : uint {
			for (var i : int = 0; i < a.length ; i++) {
				if (!isCaseInsensitive) {
					if (a[i][prop] == val) return i;
				} else {
					if (a[i][prop].toUpperCase( ) == String( val ).toUpperCase( )) return i;	
				}
			}
			return NaN;
		}

		/**
		 * Return a new array sliced from the original array of complex objects based on a <code>prop</code>/<code>val</code> match
		 * @param a 					array of objects.
		 * @param prop 					array object property to locate.
		 * @param val 					array object property value to match.
		 * @param isCaseInsensitive 	define whether <code>prop</code>/<code>val</code> should be case-insensitive (use only if search <code>val</code> is <code>String</code>).
		 * @return Array 				of objects that contain the <code>prop</code>/<code>val</code> match.
		 */
		public static function sliceByPropVal(a : Array, prop : String, val : Object, isCaseInsensitive : Boolean = false) : Array {
			var ma : Array = new Array( );
			for(var o :String in a) {
				if (!isCaseInsensitive) {
					if (a[o][prop] == val) ma.push( a[o] );
				} else {
					if (a[o][prop].toUpperCase( ) == String( val ).toUpperCase( )) ma.push( a[o] );	
				}
			}
			return ma;	
		}	

		/**
		 * Locate and return the (lowest) nearest neighbor or matching value in a <code>NUMERIC</code> sorted array of Numbers.
		 * @param val 				the value to find match or find nearst match of.
		 * @param range 			of values in array.
		 * @param returnIndex 		if <code>true</code> return the array index of the neighbor, if <code>false</code> return the value of the neighbor.
		 * @example <listing version="3.0">
		 * var a : Array = [1, 3, 5, 7, 9, 11];
		 * var nearestLow : Number = ArrayUtil.nearestNeighbor(4, a); 			// returns 3 (value)
		 * var nearestHigh : Number = ArrayUtil.nearestNeighbor(4, a, true); 	// returns 1 (index) 
		 * </listing>
		 */
		public static function nearestNeighbor(val : Number, range : Array, returnIndex : Boolean = false) : Number {
			var nearest : Number = range[0];
			var index : uint = 0;
			for (var i : int = 1; i < range.length ; i++) {
				if (Math.abs( range[i] - val ) < Math.abs( nearest - val )) {
					nearest = range[i];
					index = i;
				}
			}
			return (!returnIndex) ? nearest : index;
		}

		/**
		 * Return the array index of the minimum value in a numeric array.
		 */
		public static function min(a : Array) : int {
			var i : int = a.length;
			var min : Number = a[0];
			var idx : int = 0;
			while (i-- > 1) {
				if(a[i] < min) min = a[idx = i];
			}
			return idx;
		}

		/**
		 * Return the array index of the maximum value in a numeric array.
		 */	
		public static function max(a : Array) : int {
			var i : int = a.length;
			var max : Number = a[0];
			var idx : int = 0;	
			while(i-- > 1) {
				if(a[i] > max) max = a[idx = i];
			}
			return idx;	
		}

		/**
		 * Return the minimum value in a numeric array.
		 * @return Number 	minimum value (0 is returned with 0 length arrays)
		 */	
		public static function minVal(a : Array) : Number {
			return ((a.length <= 0) ? 0 : a[ArrayUtils.max( a )]);
		}

		/**
		 * Return the maximum value in a numeric array.
		 * @return Number 	maximum value
		 */	
		public static function maxVal(a : Array) : Number {
			return ((a[ArrayUtils.max( a )] < 0) ? 0 : a[ArrayUtils.max( a )]);
		}
	}
}
