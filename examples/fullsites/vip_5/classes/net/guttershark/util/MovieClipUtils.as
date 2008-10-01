package net.guttershark.util 
{
	import flash.display.MovieClip;			

	/**
	 * The MovieClipUtils Class has utility methods that decrease
	 * amount of code you have to write for numerous situations.
	 */
	public class MovieClipUtils 
	{
		
		/**
		 * Set the buttonMode property on all clips provided.
		 * @param	value	The value to set the buttonMode property to.
		 * @param	...clips	An array of movie clips.
		 */
		public static function SetButtonMode(value:Boolean, ...clips:Array):void
		{
			for each(var clip:MovieClip in clips)
			{
				clip.buttonMode = value;
			}
		}
		
		/**
		 * Set the visible property on all clips provided.
		 * @param	value	The value to set the visible property to.
		 * @param	...clips	An array of movie clips.
		 */
		public static function SetVisible(value:Boolean, ...clips:Array):void
		{
			for each(var clip:MovieClip in clips)
			{
				clip.visible = value;
			}
		}
		
		/**
		 * Set the alpha property on all clips provided.
		 * @param	value	The value to set the alpha to.
		 * @param	...clips	An array of movie clips.
		 */
		public static function SetAlpha(value:Number, ...clips:Array):void
		{
			for each(var clip:MovieClip in clips)
			{
				clip.alpha = value;
			}
		}
		
		/**
		 * Set the cacheAsBitmap property on all movie clips provided.
		 * @param	value	The value to set the cacheAsBitmap property to.
		 * @param	...clips	An array of movie clips.
		 */
		public function SetCacheAsBitmap(value:Boolean, ...clips:Array):void
		{
			for each(var clip:MovieClip in clips)
			{
				clip.cacheAsBitmap = value;
			}
		}
		
		/**
		 * Set the useHandCursor property on all movie clips provided.
		 * @param	value	The value to set the useHandCursor property to.
		 * @param	...clips	An array of movie clips.
		 */
		public function SetUseHandCursor(value:Boolean, ...clips:Array):void
		{
			for each(var clip:MovieClip in clips)
			{
				clip.useHandCursor = value;
			}
		}		}}