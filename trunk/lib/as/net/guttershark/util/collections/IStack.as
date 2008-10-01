package net.guttershark.util.collections{	import net.guttershark.util.collections.ICollection;	/**	 * IStack defines the stack data structure.  A stack is a special collection type in which	 * the last element added to it is the next one returned. You add elements via push & pop.	 */	public interface IStack extends ICollection 	{		/**		 * The object at the top of our stack, which would be return and removed on a 		 * subsequent call to <code>pop</code>.		 */		function get top():Object;		/**		 * Add an element to the top of the stack.		 */		function push( o:Object ):void;		/**		 * Remove and return the element at the top of the stack.		 */		function pop():Object;			}}