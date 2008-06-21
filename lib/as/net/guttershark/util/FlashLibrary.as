package net.guttershark.util
{
	
	import flash.display.Bitmap;	
	import flash.text.Font;	
	import flash.media.Sound;	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.*;
	
	/**
	 * The FlashLibrary class simplifies getting items from the Flash Library at runtime,
	 * and provides shortcuts for common types of assets you need to get out of
	 * the library.
	 */
	public class FlashLibrary
	{
		
		/**
		 * Get a Class reference to a definition in the movie.
		 * 
		 * @example Getting a movie clip from the library at runtime.
		 * <listing>
		 * var mc:MovieClip = Library.GetMovieClip("myMovieClipLinkID");
		 * </listing>
		 * 
		 * @param	classIdentifier		The item name in the library.
		 * @return	Class	A Class reference.
		 */
		public static function GetClassReference(classIdentifier:String):Class
		{
			return flash.utils.getDefinitionByName(classIdentifier) as Class;
		}
		
		/**
		 * Get an item in the library as a Sprite.
		 * 
		 * @param	classIdentifier	The name of the item in the library.
		 * @return	Sprite	The item as a Sprite.
		 */
		public static function GetSprite(classIdentifier:String):Sprite
		{
			var instance:Class = flash.utils.getDefinitionByName(classIdentifier) as Class;
			var s:Sprite = new instance() as Sprite;
			return s;
		}
		
		/**
		 * Get an item in the library as a MovieClip.
		 * 
		 * @param	classIdentifier	The name of the item in the library.
		 * @return	MovieClip	The item as a movie clip.
		 */
		public static function GetMovieClip(classIdentifier:String):MovieClip
		{
			var instance:Class = flash.utils.getDefinitionByName(classIdentifier) as Class;
			var s:MovieClip = new instance() as MovieClip;
			return s;
		}
		
		/**
		 * Get an item in the library as a Sound.
		 * 
		 * @param	classIdentifier	The name of the item in the library.
		 * @return	Sound	The item as a movie clip.
		 */
		public static function GetSound(classIdentifier:String):Sound
		{
			var instance:Class = flash.utils.getDefinitionByName(classIdentifier) as Class;
			var s:Sound = new instance() as Sound;
			return s;
		}
		
		/**
		 * Get an item in the library as a Bitmap.
		 * 
		 * @param	classIdentifier	The name of the item in the library.
		 * @return	Bitmap	The item as a Bitmap.
		 */
		public static function GetBitmap(classIdentifier:String):Bitmap
		{
			var instance:Class = flash.utils.getDefinitionByName(classIdentifier) as Class;
			var b:Bitmap = new instance() as Bitmap;
			return b;
		}
		
		/**
		 * Get an item in the library as a Font.
		 * 
		 * @param	classIdentifier	The name of the item in the library.
		 * @return	Font	The item as a Font.
		 */
		public static function GetFont(classIdentifier:String):Font
		{
			var instance:Class = flash.utils.getDefinitionByName(classIdentifier) as Class;
			var f:Font = new instance() as Font;
			Font.registerFont(instance);
			return f;
		}
	}
}