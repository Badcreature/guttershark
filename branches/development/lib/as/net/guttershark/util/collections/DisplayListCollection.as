package net.guttershark.util.collections{	import flash.display.DisplayObjectContainer;	import net.guttershark.util.collections.DisplayListIterator;	import net.guttershark.util.collections.ICollection;	import net.guttershark.util.collections.IIterator;		/**	 * DisplayList based Collection	 */	public class DisplayListCollection implements ICollection 	{		private var _container:DisplayObjectContainer;		/**		 * DisplayListCollection Constructor		 * @param container	DisplayObjectContainer used in collection.		 */		public function DisplayListCollection(container:DisplayObjectContainer) 		{			_container = container;		}		/**		 * @inheritDoc		 */		public function getIterator():IIterator 		{			return new DisplayListIterator(_container);		}		/**		 * @inheritDoc		 */		public function clear():void 		{			while ( _container.numChildren ) 			{				_container.removeChildAt(0);			}		}		/**		 * @inheritDoc		 */		public function get count():uint		{			return _container.numChildren;		}		/**		 * @inheritDoc		 */		public function get isEmpty():Boolean 		{			return count == 0;		}		/**		 * Return the collection container data		 */		public function get container():DisplayObjectContainer 		{ 			return _container; 		}	}}