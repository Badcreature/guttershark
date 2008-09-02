package net.guttershark.util.collections{	import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.display.Sprite;	import net.guttershark.util.collections.DisplayListCollection;	import net.guttershark.util.collections.IQueue;		/**	 * DisplayList based Queue data structure.	 */	public class DisplayListQueue extends DisplayListCollection implements IQueue 	{		/**		 * DisplayListQueue Constructor creates a new <code>DisplayListQueue</code>.		 * You may have it wrap an existing <code>DisplayObjectContainer</code> 		 * or the constructor will create an empty <code>Sprite</code> for you.		 */		public function DisplayListQueue(container:DisplayObjectContainer = null) 		{			if ( !container ) container = new Sprite();			super(container);		}		/**		 * @inheritDoc		 */		public function get head():Object 		{			return container.getChildAt(0);		}		/**		 * @inheritDoc		 */		public function enqueue(o:Object):void 		{			if ( !(o is DisplayObject ) ) throw new ArgumentError("Require an object of type DisplayObject.");							container.addChild(o as DisplayObject);					}		/**		 * @inheritDoc		 */		public function dequeue():Object 		{			return container.removeChildAt(0);		}	}}