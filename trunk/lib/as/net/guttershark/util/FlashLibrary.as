package net.guttershark.util
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.utils.*;
	import flash.utils.flash_proxy;
	
	import net.guttershark.core.Singleton;	

	/**
	 * The FlashLibrary class simplifies getting items from the Flash Library at runtime,
	 * and provides shortcuts for common types of assets you need to get out of
	 * the library.
	 * 
	 * <p>The FlashLibrary provides static methods as shortcuts, but also allows
	 * dynamic use to get instances of classes from the library.</p>
	 * 
	 * @example Examples of both types of use:
	 * <listing>
	 * //traditional:
	 * var mc:MovieClip = FlashLibrary.GetMovieClip("Test") as MovieClip;
	 * 
	 * //dynamic:
	 * //this will work for any library symbol that can be exported.
	 * var fb:FlashLibrary = FlashLibrary.gi();
	 * var mc2:MovieClip = fb.Test; //creates a new instance of the MovieClip with the class exported as "Test".
	 * var snd:Sound = fb.MySound; //creates a new MySound instance.
	 * </listing>
	 */
	dynamic public class FlashLibrary extends Proxy
	{
		
		//singleton instance
		private static var inst:FlashLibrary;
		
		/**
		 * @private
		 */
		public function FlashLibrary():void
		{
			//Singleton.assertSingle(FlashLibrary);
		}
		
		/**
		 * singleton access
		 */
		public static function gi():FlashLibrary
		{
			if(!inst) inst = Singleton.gi(FlashLibrary);
			return inst;
		}
		
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
		
		/**
		 * The gc method returns a class reference for an identifier
		 * in the library. This is specifically for using the new operator.
		 * 
		 * <p><em><code>gc</code></em> stands for "get class"</p>
		 * 
		 * @example Using the gc method to create a new movie clip from the library:
		 * <listing>
		 * var mc:MovieClip = new (fl.gc("Test")) as MovieClip;
		 * </listing>
		 */
		public static function gc(classIdentifier:String):*
		{
			var instance:Class = flash.utils.getDefinitionByName(classIdentifier) as Class;
			return instance;
		}
		
		/**
		 * FlashLibrary overrides the getProperty proxy method for dynamic
		 * use. You can grab an instance of a symbol from the library
		 * as if it's a property of the flash library class.
		 * 
		 * @example Get an instance from the library:
		 * <listing>	
		 * var fb:FlashLibrary = FlashLibrary.gi();
		 * trace(fb.Test); //"Test" should be a movie clip in the library with the class export name as "Test"
		 * </listing>
		 * 
		 * getProperty - override getters to return null always
		 */
		flash_proxy override function getProperty(name:*):* 
		{
			Assert.True(ApplicationDomain.currentDomain.hasDefinition(name),"Class {"+name+"} is not defined in this swf.",Error);
			var klass:Class = flash.utils.getDefinitionByName(name) as Class;
			var i:* = new klass();
			return i;
		}
	}
}