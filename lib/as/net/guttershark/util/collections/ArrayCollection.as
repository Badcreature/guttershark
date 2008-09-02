package net.guttershark.util.collections{	import net.guttershark.util.collections.ArrayIterator;	import net.guttershark.util.collections.ICollection;	import net.guttershark.util.collections.IIterator;	
	/**	 * Array based Collection	 */	public class ArrayCollection implements ICollection 
	{
		protected var _array:Array;
		/**		 * ArrayCollection Constructor		 * @param array	Array of data used in collection.		 */		public function ArrayCollection(array:Array) 
		{			_array = array.concat();		}
		/**		 * Returns an IIterator which traverses the items in the collection 		 * starting at index 0, and going to index length-1.		 */		public function getIterator():IIterator 
		{			return new ArrayIterator(_array.slice(0));		}
		/**		 * @inheritDoc		 */		public function clear():void 
		{			while ( length > 0 ) 
			{				_array.pop();			}		}		
		/**		 * @inheritDoc		 */		public function get count():uint 
		{			return _array.length;		}
		/**		 * @inheritDoc		 */		public function get isEmpty():Boolean 
		{			return (_array.length <= 0);		}
		/**		 * Return the collection array data		 */		public function get array():Array 
		{ 			return _array; 		}			}}