package net.guttershark.util.collections{	import net.guttershark.util.collections.ArrayQueue;	import net.guttershark.util.collections.IDestructiveIterator;	import net.guttershark.util.collections.IIterator;	import net.guttershark.util.collections.IStack;		/**	 * Stack based Iterator	 */	public class StackIterator implements IIterator, IDestructiveIterator 	{		private var _queue:ArrayQueue;		/**		 * StackIterator Constructor		 */		public function StackIterator(stack:IStack) 		{			_queue = new ArrayQueue();			while ( !stack.isEmpty ) 			{				_queue.enqueue(stack.pop());			}			var elements:Array = _queue.array.slice(0);			while ( elements.length ) 			{				stack.push(elements.pop());						}		}		/**		 * @inheritDoc		 */		public function hasNext():Boolean 		{			return !_queue.isEmpty;				}		/**		 * @inheritDoc		 */		public function next():Object 		{			return _queue.dequeue();		}		/**		 * @inheritDoc		 */		public function peek():Object 		{			return _queue.head;		}	}}