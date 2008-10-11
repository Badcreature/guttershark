package net.guttershark.util.collections 
{
	/**	 * The ArrayBounceIterator class provides a non-destructive,
	 * pointer-based, bouncing array iterator which moves
	 * to the end of the array then reverses direction backward
	 * & forward.	 */	final public class ArrayBounceIterator	{		
		/**
		 * @private
		 */		protected var _array:Array;		
		/**
		 * @private
		 */
		protected var _pointer:int;		
		/**
		 * @private
		 */
		protected var _isForward:Boolean;		
		/**
		 * @private
		 */
		protected var _isSkipRepeat:Boolean;				/**		 * Constructor for ArrayBounceIterator instances.		 * @param array The array to iterate over.		 * @param skipDuplicate If <code>true</code> iterate <code>0,1,2,1,0</code> rather than <code>0,1,2,2,1,0</code>.		 */		public function ArrayBounceIterator(array:Array, isSkipRepeat:Boolean = true) 		{			_array = array.concat();			_isSkipRepeat = isSkipRepeat;			reset();		}				/**		 * The next element, or null.		 */		public function next():Object 		{			var p:int = movePointer();			return hasNext() ? _array[p] : null;		}						/**		 * The current element.		 */		public function current():Object 		{			return _array[_pointer];		}				/**		 * Resets the pointer.		 */		public function reset():void 		{			_pointer = -1;			_isForward = true;		}			/**		 * There will always be a next item, as
		 * when the pointer is at the end, it switches
		 * direction.		 */		public function hasNext():Boolean 		{			return true;		}				/**		 * Return a <code>peek</code> of the next element without 
		 * updating the array element pointer, or return
		 * <code>null</code> if none.		 */		public function peek():Object 		{			return _array[movePointer(true)];		}		/**
		 * @private		 * Move the pointer in the proper direction; bounce at either end.		 * @param isPreview if <code>true</code> the pointer will not be iterated; but will return a preview pointer index.		 */		protected function movePointer(isPreview:Boolean=false):int 		{			var p:int = _pointer;			if(_isForward) 			{				if(p<_array.length-1)p++;				else				{					_isForward=false;					var restep:int=(_isSkipRepeat)?2:1;					p=_array.length-restep;					}			} 
			else 			{				if(p>0)p--;				else 				{					_isForward=true;					p=(_isSkipRepeat)?1:0;				}			}			if(!isPreview) _pointer = p;			return p;		}		/**		 * The collection length.		 */		public function get length():int		{			return _array.length;		}		/**
		 * @private		 * The interative pointer index.		 */		public function get pointer():int 		{			return _pointer;		}		/**		 * @private		 */		public function set pointer(i:int):void 		{			_pointer = i;		}
		
		/**
		 * Dispose of this iterator.
		 */
		public function dispose():void
		{
			_pointer = 0;
			_array = null;
			_isForward = false;
			_isSkipRepeat = false;
		}	}}