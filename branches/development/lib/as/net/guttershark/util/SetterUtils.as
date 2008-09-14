package net.guttershark.util 
{

	/**
	 * The SetterUtils Class has utility methods that decrease
	 * amount of code you have to write for setting the same
	 * properties on multiple objects.
	 */
	public class SetterUtils 
	{
		
		/**
		 * Set the buttonMode property on all objects provided.
		 * 
		 * @param	value	The value to set the buttonMode property to.
		 * @param	...clips	An array of objects that have the buttonMode property.
		 */
		public static function buttonMode(value:Boolean, ...objs:Array):void
		{
			for each(var obj:* in objs) obj.buttonMode = value;
		}
		
		/**
		 * Set the visible property on all objects provided.
		 * 
		 * @param	value	The value to set the visible property to.
		 * @param	...clips	An array of objects with the visible property.
		 */
		public static function visible(value:Boolean, ...clips:Array):void
		{
			for each(var clip:* in clips) clip.visible = value;
		}
		
		/**
		 * Set the alpha property on all objects provided.
		 * 
		 * @param	value	The value to set the alpha to.
		 * @param	...clips	An array of objects with an alpha property.
		 */
		public static function alpha(value:Number, ...clips:Array):void
		{
			for each(var clip:* in clips) clip.alpha = value;
		}
		
		/**
		 * Set the cacheAsBitmap property on all objects provided.
		 * 
		 * @param	value	The value to set the cacheAsBitmap property to.
		 * @param	...clips	An array of objects with the cacheAsBitmap property.
		 */
		public function cacheAsBitmap(value:Boolean, ...clips:Array):void
		{
			for each(var clip:* in clips) clip.cacheAsBitmap = value;
		}
		
		/**
		 * Set the useHandCursor property on all objects provided.
		 * 
		 * @param	value	The value to set the useHandCursor property to.
		 * @param	...clips	An array of objects with the useHandCursor property.
		 */
		public function useHandCursor(value:Boolean, ...clips:Array):void
		{
			for each(var clip:* in clips) clip.useHandCursor = value;
		}	
		
		/**
		 * Set the mouseChildren property on all objects provided.
		 * @param value An array of objects with the useHandCursor property.
		 */
		public static function mouseChildren(value:Boolean,...clips:Array):void
		{
			for each(var clip:* in clips) clip.mouseChildren = value;
		}
		
		/**
		 * Set tab index's on multiple textfields.
		 * 
		 * @param	...fields	The textfields to set tabIndex on.
		 */
		public static function tabIndex(...fields:Array):void
		{
			var i:int = 0;
			while(fields[i]!=null){fields[i].tabIndex=(i+1);i++;};
		}
		
		/**
		 * Set the autoSize property on multiple textfields.
		 * 
		 * @param	value	The autoSize value.
		 * @param	...fields	The textfields to set the autoSize property on.
		 */
		public static function autoSize(value:String, ...fields:Array):void
		{
			var i:int = 0;
			while(fields[i]!=null){fields[i].autoSize=value;i++;};
		}
	}
}