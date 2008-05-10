package net.guttershark.util 
{

	import flash.display.DisplayObjectContainer;
	
	/**
	 * The DisplayListUtils class has utility methods for working with the Display list.
	 */
	public class DisplayListUtils 
	{
		
		/**
		 * Remove all children from a sprite.
		 * 
		 * @example Removing all children from a sprite.
		 * <listing>	
		 * var container:Sprite = new Sprite();
		 * addChild(container);
		 * var child1:Sprite = new Sprite();
		 * car child2:Sprite = new Sprite();
		 * container.addChild(child1);
		 * container.addChild(child2);
		 * DisplayListUtils.RemoveAllChildren(container);
		 * </listing>
		 * 
		 * @param	sprite	The sprite to remove all children from.
		 */	
		public static function RemoveAllChildren(doc:DisplayObjectContainer):void
		{
			try
			{
				while(doc.removeChildAt(0)){}
			}
			catch(re:RangeError){}
		}
		
		/**
		 * Add multiple children onto a display object container.
		 * @param	doc	The display object container to add children too.
		 * @param	children	The children display objects to add to the container.
		 */
		public static function AddChildren(doc:DisplayObjectContainer, children:Array):void
		{
			var l:int = children.length;
			for(var i:int = 0; i < l; i++) doc.addChild(children[i]);
		}
	}
}
