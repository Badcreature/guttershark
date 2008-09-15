package net.guttershark.util 
{

	/**
	 * The SetterUtils class has utility methods that decrease
	 * amount of code you have to write for setting the same
	 * properties on multiple objects.
	 */
	final public class SetterUtils 
	{
		
		/**
		 * Set the buttonMode property on all objects provided.
		 * 
		 * @param value The value to set the buttonMode property to.
		 * @param ...objs An array of objects that have the buttonMode property.
		 */
		public static function buttonMode(value:Boolean, ...objs:Array):void
		{
			for each(var obj:* in objs) obj.buttonMode = value;
		}
		
		/**
		 * Set the visible property on all objects provided.
		 * 
		 * @param value The value to set the visible property to.
		 * @param ...objs An array of objects with the visible property.
		 */
		public static function visible(value:Boolean, ...objs:Array):void
		{
			for each(var clip:* in objs) clip.visible = value;
		}
		
		/**
		 * Set the alpha property on all objects provided.
		 * 
		 * @param value The value to set the alpha to.
		 * @param ...objs An array of objects with an alpha property.
		 */
		public static function alpha(value:Number, ...objs:Array):void
		{
			for each(var clip:* in objs) clip.alpha = value;
		}
		
		/**
		 * Set the cacheAsBitmap property on all objects provided.
		 * 
		 * @param value The value to set the cacheAsBitmap property to.
		 * @param ...objs An array of objects with the cacheAsBitmap property.
		 */
		public function cacheAsBitmap(value:Boolean, ...objs:Array):void
		{
			for each(var clip:* in objs) clip.cacheAsBitmap = value;
		}
		
		/**
		 * Set the useHandCursor property on all objects provided.
		 * 
		 * @param value The value to set the useHandCursor property to.
		 * @param ...objs An array of objects with the useHandCursor property.
		 */
		public function useHandCursor(value:Boolean, ...objs:Array):void
		{
			for each(var clip:* in objs) clip.useHandCursor = value;
		}	
		
		/**
		 * Set the mouseChildren property on all objects provided.
		 * 
		 * @param value The value to set the mouseChildren property to on all objects.
		 * @param ...objs An array of objects with the mouseChildren property.
		 */
		public static function mouseChildren(value:Boolean,...objs:Array):void
		{
			for each(var clip:* in objs) clip.mouseChildren = value;
		}
		
		/**
		 * Set the mouseEnabled property on all objects provided.
		 * 
		 * @param value The value to set the mouseEnabled property to on all objects.
		 * @param ..objs An array of objects with the mouseEnabled property.
		 */
		public static function mouseEnabled(value:Boolean,...objs:Array):void
		{
			for each(var clip:* in objs) clip.mouseEnabled = value;
		}
		
		/**
		 * Set tab index's on multiple textfields.
		 * 
		 * @param ...fields The textfields to set tabIndex on.
		 */
		public static function tabIndex(...fields:Array):void
		{
			var i:int = 0;
			while(fields[i]!=null){fields[i].tabIndex=(i+1);i++;};
		}
		
		/**
		 * Set the tabChildren property on all objects passed.
		 * 
		 * @param The value to set the tabChildren property to on all objects.
		 * @param ..objs An array of objects with the tabChildren property.
		 */
		public static function tabChildren(value:Boolean,...objs:Array):void
		{
			for each(var clip:* in objs) clip.tabChildren = value;
		}
		
		/**
		 * Set the tabEnabled property on all objects passed.
		 * 
		 * @param The value to set the tabChildren property to on all objects.
		 * @param ..objs An array of objects with the tabEnabled property.
		 */
		public static function tabEnabled(value:Boolean,...objs:Array):void
		{
			for each(var clip:* in objs) clip.tabChildren = value;
		}
		
		/**
		 * Set the autoSize property on multiple textfields.
		 * 
		 * @param value The autoSize value.
		 * @param ...fields The textfields to set the autoSize property on.
		 */
		public static function autoSize(value:String, ...fields:Array):void
		{
			var i:int = 0;
			while(fields[i]!=null){fields[i].autoSize=value;i++;};
		}
	}
}