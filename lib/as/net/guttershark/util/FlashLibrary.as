package net.guttershark.util
{
	import flash.display.Bitmap;	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.media.Sound;	import flash.text.Font;	import flash.utils.*;		import net.guttershark.util.Singleton;	
	/**
	 * The FlashLibrary class simplifies getting items from the
	 * Flash Library at runtime, and provides shortcuts for common
	 * types of assets you need to get out of the library.
	 */
	final public class FlashLibrary extends Proxy
	{
		
		/**
		 * Singleton instance.
		 */
		private static var inst:FlashLibrary;
		
		/**
		 * @private
		 */
		public function FlashLibrary():void
		{
			Singleton.assertSingle(FlashLibrary);
		}
		
		/**
		 * Singleton access
		 */
		public static function gi():FlashLibrary
		{
			if(!inst) inst = Singleton.gi(FlashLibrary);
			return inst;
		}
		
		/**
		 * Get a Class reference to a definition in the movie.
		 * 
		 * @param classIdentifier The item name in the library.
		 */
		public function klass(classIdentifier:String):Class
		{
			return flash.utils.getDefinitionByName(classIdentifier) as Class;
		}
		
		/**
		 * Get an item in the library as a Sprite.
		 * 
		 * @param classIdentifier The name of the item in the library.
		 */
		public function sprite(classIdentifier:String):Sprite
		{
			var instance:Class = flash.utils.getDefinitionByName(classIdentifier) as Class;
			var s:Sprite = new instance() as Sprite;
			return s;
		}
		
		/**
		 * Get an item in the library as a MovieClip.
		 * 
		 * @param classIdentifier The name of the item in the library.
		 */
		public static function movieclip(classIdentifier:String):MovieClip
		{
			var instance:Class = flash.utils.getDefinitionByName(classIdentifier) as Class;
			var s:MovieClip = new instance() as MovieClip;
			return s;
		}
		
		/**
		 * Get an item in the library as a Sound.
		 * 
		 * @param classIdentifier The name of the item in the library.
		 */
		public static function sound(classIdentifier:String):Sound
		{
			var instance:Class = flash.utils.getDefinitionByName(classIdentifier) as Class;
			var s:Sound = new instance() as Sound;
			return s;
		}
		
		/**
		 * Get an item in the library as a Bitmap.
		 * 
		 * @param classIdentifier The name of the item in the library.
		 */
		public static function bitmap(classIdentifier:String):Bitmap
		{
			var instance:Class = flash.utils.getDefinitionByName(classIdentifier) as Class;
			var b:Bitmap = new instance() as Bitmap;
			return b;
		}
		
		/**
		 * Get an item in the library as a Font.
		 * 
		 * @param classIdentifier The name of the item in the library.
		 */
		public static function font(classIdentifier:String):Font
		{
			var instance:Class = flash.utils.getDefinitionByName(classIdentifier) as Class;
			var f:Font = new instance() as Font;
			Font.registerFont(instance);
			return f;
		}
	}
}