package net.guttershark.util.collections 
{
	/**
	 * pointer-based, bouncing array iterator which moves
	 * to the end of the array then reverses direction backward
	 * & forward.
		/**
		 * @private
		 */
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
		protected var _isSkipRepeat:Boolean;
		 * when the pointer is at the end, it switches
		 * direction.
		 * updating the array element pointer, or return
		 * <code>null</code> if none.
		 * @private
			else 
		 * @private
		
		/**
		 * Dispose of this iterator.
		 */
		public function dispose():void
		{
			_pointer = 0;
			_array = null;
			_isForward = false;
			_isSkipRepeat = false;
		}