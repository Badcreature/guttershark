package net.guttershark.preloading
{

	import flash.display.Sprite;
	import flash.text.Font;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	import net.guttershark.util.Assert;	
	import net.guttershark.util.XMLLoader;
	import net.guttershark.core.IDisposable;
	import net.guttershark.errors.AssetError;
	
	/**
	 * The AssetLibrary is a singleton that stores all assets
	 * loaded by any PreloadController.
	 * 
	 * @see net.guttershark.preloading.PreloadController PreloadController class
	 */
	public class AssetLibrary implements IDisposable
	{	
		
		/**
		 * Singleton instance.
		 */
		private static var inst:AssetLibrary;
		
		/**
		 * Store for assets.
		 */
		private var assets:Dictionary;

		/**
		 * @private
		 * Constructor for AssetLibrary instances.
		 */
		public function AssetLibrary()
		{
			assets = new Dictionary(false);
		}
		
		/**
		 * Singleton Instance.
		 */
		public static function gi():AssetLibrary
		{
			if(!inst) inst = new AssetLibrary();
			return inst;
		}
		
		/**
		 * Register an asset in the library.
		 * 
		 * @param	libraryName		The item id.
		 * @param	obj				The loaded asset object.
		 * @throws	ArgumentError	If libraryName is null.
		 * @throws	ArgumentError	If obj is null.
		 */
		public function addAsset(libraryName:String, obj:*):void
		{
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			Assert.NotNull(obj, "Parameter obj cannot be null");
			if(assets[libraryName]) trace("WARNING: The asset defined by libraryName: {" + libraryName + "} already had an asset registered in the library. The previous asset is no longer available.");
			assets[libraryName] = obj;
		}
		
		/**
		 * Remove an asset from the library.
		 * 
		 * @param	libraryName	The asset's libraryName to remove.
		 * @throws	ArgumentError	If libraryName is null.
		 */
		public function removeAsset(libraryName:String):void
		{
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			assets[libraryName] = null;
		}
		
		/**
		 * Check to see if an asset is available in the library.
		 * 
		 * @param	libraryName	The libraryName used to register the asset.
		 * @return	Boolean
		 */
		public function isAvailable(libraryName:String):Boolean
		{
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null.");
			if(assets[libraryName]) return true;
			return false;
		}
		
		/**
		 * A generic method to get any asset from the library.
		 * 
		 * @param	libraryName		The library name used when the asset was registered.
		 * @throws	Error	If the inZipLibrary specified was not a zip registered in the library.
		 * @throws	Error	If the asset was not registered in the library.
		 * @return	*				The asset is returned un-typed.
		 */
		public function getAsset(libraryName:String):*
		{
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			if(!assets[libraryName]) throw new AssetError("Item not registered in library with the id: " + libraryName);
			return assets[libraryName];
		}
		
		/**
		 * Get a SWF asset from the library.
		 * 
		 * <p>The asset is cast as a Loader class</p>
		 * 
		 * @param	libraryName		The library name used when the asset was registered.
		 * @return	Loader			Returns the asset as a Loader.
		 * @see flash.display.Loader Loader class
		 */
		public function getSWF(libraryName:String):Loader
		{
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			if(assets[libraryName] != null) return getAsset(libraryName) as Loader;
			throw new AssetError("SWF {" + libraryName + "} was not found");
		}
		
		/**
		 * Get a Class reference from a swf library.
		 * 
		 * @param	libraryName			The library name used when the asset was registered.
		 * @param	classNameInLibrary	The class name in the loaded swf's library.
		 * @return 	MovieClip			Returns the asset as a MovieClip
		 */
		public function getClassFromSWFLibrary(libraryName:String, classNameInLibrary:String):Class
		{
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			Assert.NotNull(classNameInLibrary,"Parameter classNameInLibrary cannot be null");
			if(assets[libraryName] != null)
			{
				var swf:Loader = getAsset(libraryName) as Loader;
				var SymbolClass:Class = swf.contentLoaderInfo.applicationDomain.getDefinition(classNameInLibrary) as Class;
				return SymbolClass;
			}
			throw new AssetError("No class reference: {" + classNameInLibrary + "} in swf {" + libraryName + "} was found");
		}
		
		/**
		 * Get a movie clip from a swf library.
		 * 
		 * @param	libraryName			The library name used when the asset was registered.
		 * @param	classNameInLibrary	The class name in the loaded swf's library.
		 * @return 	MovieClip			Returns the asset as a MovieClip
		 */
		public function getMovieClipFromSWFLibrary(libraryName:String, classNameInLibrary:String):MovieClip
		{
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			Assert.NotNull(classNameInLibrary,"Parameter classNameInLibrary cannot be null");
			if(assets[libraryName] != null)
			{
				var swf:Loader = getAsset(libraryName) as Loader;
				var SymbolClassMC:Class = swf.contentLoaderInfo.applicationDomain.getDefinition(classNameInLibrary) as Class;
				var symbolInstance:MovieClip = new SymbolClassMC() as MovieClip;
				return symbolInstance;
			}
			throw(new AssetError("No movie clip: {" + classNameInLibrary + "} in swf {" + libraryName + "} was found"));
		}
		
		/**
		 * Get a sprite from a swf library.
		 * 
		 * @param	libraryName		The library name used when the asset was registered.
		 * @param	classNameInLibrary		The class name in the loaded swf's library.
		 * @param	inZipLibrary	If the asset was in a zip file, provide the libraryName used to register that zip in the library.
		 * @return	Sprite		Returns the asset as a MovieClip
		 */
		public function getSpriteFromSWFLibrary(libraryName:String, classNameInLibrary:String):Sprite
		{
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			Assert.NotNull(classNameInLibrary,"Parameter classNameInLibrary cannot be null");
			if(assets[libraryName] != null)
			{
				var swf:Loader = getAsset(libraryName) as Loader;
				var SymbolClassMC:Class = swf.contentLoaderInfo.applicationDomain.getDefinition(classNameInLibrary) as Class;
				var symbolInstance:Sprite = new SymbolClassMC() as Sprite;
				return symbolInstance;
			}
			throw(new AssetError("No sprite: {" + classNameInLibrary + "} in swf {" + libraryName + "} was found"));
		}
		
		/**
		 * Get an embedded Font from a SWF library. The Font is also registered
		 * through Font.registerFont before it's returned.
		 * 
		 * @param	libraryName	The library name used when the asset was registered.
		 * @param	fontLinkageId	The font linkage id.
		 * @return 	Font	Returns a Font instance.
		 */
		public function getFontFromSWFLibrary(libraryName:String, fontLinkageId:String):Font
		{
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			Assert.NotNull(fontLinkageId,"Parameter fontLinkageId cannot be null");
			if(assets[libraryName] != null)
			{
				var swf:Loader = getAsset(libraryName) as Loader;
				var FontClass:Class = swf.contentLoaderInfo.applicationDomain.getDefinition(fontLinkageId) as Class;
				Font.registerFont(FontClass);
				var fontInstance:Font = new FontClass();
				return fontInstance;
			}
			throw(new AssetError("No font: {" + fontLinkageId + "} in swf {" + libraryName + "} was found"));
		}
		
		/**
		 * Get a Bitmap from a swf library.
		 * 
		 * @param	libraryName		The library name used when the asset was registered.
		 * @param	bitmapLinkageId		The bitmaps linkage Id.
		 * @return 	Bitmap	Returns a Font instance.
		 */
		public function getBitmapFromSWFLibrary(libraryName:String, bitmapLinkageId:String):Bitmap
		{
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			Assert.NotNull(bitmapLinkageId,"Parameter bitmapLinkageId cannot be null");
			if(assets[libraryName] != null)
			{
				var swf:Loader = getAsset(libraryName) as Loader;
				var BitmapClass:Class = swf.contentLoaderInfo.applicationDomain.getDefinition(bitmapLinkageId) as Class;
				var bitmapInstance:Bitmap = new BitmapClass();
				return bitmapInstance;
			}
			throw(new AssetError("No bitmap: {" + bitmapLinkageId + "} in swf {" + libraryName + "} was found"));
		}
		
		/**
		 * Get a Sound from a swf library
		 * 
		 * @param	libraryName		The library name used when the asset was registered.
		 * @param	soundLinkageId	The sounds linkage id from the library.
		 * @param	inZipLibrary	The zip file that contains the sound, this should be the libraryName used to register the zip in the asset library.
		 * @return 	Sound	Returns a Sound instance.
		 */
		public function getSoundFromSWFLibrary(libraryName:String, soundLinkageId:String):Sound
		{
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			Assert.NotNull(soundLinkageId,"Parameter soundLinkageId cannot be null");
			if(assets[libraryName] != null)
			{
				var swf:Loader = getAsset(libraryName) as Loader;
				var SoundClass:Class = swf.contentLoaderInfo.applicationDomain.getDefinition(soundLinkageId) as Class;
				var soundInstance:Sound = new SoundClass();
				return soundInstance;
			}
			throw(new AssetError("No sound: {" + soundLinkageId + "} in swf {" + libraryName + "} was found"));
		}
		
		/**
		 * Get a loaded asset as a Bitmap.
		 * 
		 * @param	libraryName		The library name used when the asset was registered.
		 * @return	Bitmap			returns a flash.display.Bitmap asset.
		 */
		public function getBitmap(libraryName:String):Bitmap
		{
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			if(assets[libraryName] != null)
			{
				return getAsset(libraryName).contentLoaderInfo.content;
				//return Bitmap(getAsset(libraryName).content);
				//return Bitmap(getAsset(libraryName).content);
				//return BitmapUtils.CopyBitmap(getAsset(libraryName).content);
			}
			throw new AssetError("Bitmap {" + libraryName + "} was not found.");
		}
		
		/**
		 * Get a Sound asset.
		 * 
		 * @param	libraryName		The library name used when the asset was registered.
		 * @return	Sound	returns a flash.media.Sound instance.
		 */
		public function getSound(libraryName:String):Sound
		{
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			if(assets[libraryName] != null) return getAsset(libraryName) as Sound;
			throw new AssetError("Sound {" + libraryName + "} was not found.");
		}
		
		/**
		 * Get an XML asset.
		 * 
		 * @param	libraryName	The library name used when the asset was registered.
		 * @return	XML	returns the XML instance.
		 */
		public function getXML(libraryName:String):XML
		{
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			if(assets[libraryName] != null) return XMLLoader(getAsset(libraryName)).data as XML;
			throw new AssetError("XML {" + libraryName + "} was not found.");
		}

		/**
		 * Purge all assets from the library. The AssetLibrary is still
		 * usable after a dispose, just the assets are disposed of.
		 */
		public function dispose():void
		{
			assets = new Dictionary(false);
		}
	}
}