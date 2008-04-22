package net.guttershark.util
{
	import flash.media.Sound;	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.*;
	
	/**
	 * The Library class is used for getting items from the Flash Library at runtime,
	 * and provides shortcuts for common types of assets you need to get out of
	 * the library.
	 */
	public class Library
	{
		
		/**
		 * Get a Class reference to a definition in the movie.
		 * 
		 * @example Getting a movie clip from the library at runtime.
		 * <listing>
		 * var mc:MovieClip = Library.GetMovieClip("myMovieClipLinkID");
		 * </listing>
		 * 
		 * @param	libraryName		The item name in the library.
		 * @return	Class	A Class reference.
		 */
		public static function GetClassReference(libraryName:String):Class
		{
			return flash.utils.getDefinitionByName(libraryName) as Class;
		}
		
		/**
		 * Get an item in the library as a Sprite.
		 * 
		 * @param	libraryName	The name of the item in the library.
		 * @return	Sprite	The item as a Sprite.
		 */
		public static function GetSprite(libraryName:String):Sprite
		{
			var instance:Class = flash.utils.getDefinitionByName(libraryName) as Class;
			var s:Sprite = new instance() as Sprite;
			return s;
		}
		
		/**
		 * Get an item in the library as a MovieClip.
		 * 
		 * @param	libraryName	The name of the item in the library.
		 * @return	MovieClip	The item as a movie clip.
		 */
		public static function GetMovieClip(libraryName:String):MovieClip
		{
			var instance:Class = flash.utils.getDefinitionByName(libraryName) as Class;
			var s:MovieClip = new instance() as MovieClip;
			return s;
		}
		
		/**
		 * Get an item in the library as a Sound.
		 * 
		 * @param	libraryName	The name of the item in the library.
		 * @return	Sound	The item as a movie clip.
		 */
		public static function GetSound(libraryName:String):Sound
		{
			var instance:Class = flash.utils.getDefinitionByName(libraryName) as Class;
			var s:Sound = new instance() as Sound;
			return s;
		}
	}
}