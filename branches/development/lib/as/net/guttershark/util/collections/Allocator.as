package net.guttershark.util.collections{	import net.guttershark.util.collections.IAllocator;	/**	 * Allocator provides a standardized interface for the bulk allocation of objects in memory. Once populated	 * with objects that need to be cached for application use the allocator will only create new objects when	 * the requests exceeds the allocators cache.	 * 	 * <p>The benefits of using an allocator when generating large amounts of objects is two-fold:	 * <ol>	 * <li>Creation of objects is slow and can effect application performance (especially in bulk scenarios).</li>	 * <li>Manual management of the bulk creation of objects easily leads to accidental Memory Leaks if the 	 * objects are not properly Garbage Collected.</li>	 * </ol>	 * </p>	 * 	 * @example <listing version="3.0">	 * var allocator : Allocator = new Allocator( AbstractTest );	 * var test : AbstractTest;	 * 	 * trace ("Memory Initialized: " + System.totalMemory );	 * 	 * for(var i:int = 0; i < 1000; i++) {	 * 		test = allocator.getObject( );	 * }	 * trace( "Memory Loop #1: " + System.totalMemory );	 * 	 * allocator.reset( );	 * 	 * trace ("Memory: " + System.totalMemory );	 * 	 * for(var j:int = 0; j < 1000; j++) {	 * 		test = allocator.getObject( );	 * }	 * trace ("Memory Loop #2: " + System.totalMemory );	 * 	 * allocator.release( );	 * trace ("Memory Finalized: " + System.totalMemory );	 * </listing>	 */	public class Allocator implements IAllocator 	{		protected var _type:Class;		protected var _cache:Array;		protected var _index:int;		/**		 * Allocator Constructor		 * @param type of Class the Allocator class contains.		 */		public function Allocator(type:Class = null) 		{			_type = (type == null) ? Object : type;			_cache = [];			_index = 0;		}		/**		 * Retrieve an object from the Allocator cache or create a 		 * new object if the current cache has been exhausted.		 */		public function getObject():* 		{			if(_cache[_index] == null) 			{				_cache[_index] = new _type();			}			return _cache[_index++];		}		/**		 * Release the Allocator objects from memory when you no		 * longer need the cached objects.		 */		public function release():void 		{			_cache = [];			_index = 0;		}		/**		 * Reset the cache index when you have populated the Allocator		 * cache and are ready to re-use the cached objects.		 */		public function reset():void 		{			_index = 0;		}				}}