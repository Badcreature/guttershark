package net.guttershark.preloading
{

	import flash.display.Sprite;
	import flash.text.Font;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	import net.guttershark.core.IDisposable;
	
	import deng.fzip.FZipFile;
	import deng.fzip.FZip;
	
	/**
	 * The AssetLibrary is primarily used with a PreloadController, as
	 * the library in the preload controller that stores loaded Assets.
	 * 
	 * <p>This class can also be used by itself to manage assets</p>
	 * 
	 * @see net.guttershark.preloading.PreloadController PreloadController class
	 */
	public class AssetLibrary implements IDisposable
	{	

		/**
		 * Store for assets.
		 */
		private var assets:Dictionary;
		
		/**
		 * Constructor for AssetLibrary instances.
		 */
		public function AssetLibrary()
		{
			assets = new Dictionary(true);
		}

		/**
		 * Register an asset in the library.
		 * 
		 * @param	libraryName		The item id.
		 * @param	obj				The loaded asset object.
		 */
		public function addAsset(libraryName:String, obj:*):void
		{
			if(!libraryName) return;
			if(!obj) return;
			assets[libraryName] = obj;
		}
		
		/**
		 * A generic method to get any asset from the library.
		 * 
		 * @param	libraryName		The library name used when the asset was registered.
		 * @return	*				The asset is returned un-typed
		 */
		public function getAsset(libraryName:String):*
		{
			if(!assets[libraryName]) throw new Error("Item not registered in library under the id: " + libraryName);
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
			if(assets[libraryName] != null) return getAsset(libraryName) as Loader;
			throw new Error("SWF {" + libraryName + "} was not found");
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
			if(assets[libraryName] != null)
			{
				var swf:Loader = getAsset(libraryName) as Loader;
				var SymbolClass:Class = swf.contentLoaderInfo.applicationDomain.getDefinition(classNameInLibrary) as Class;
				return SymbolClass;
			}
			throw(new Error("No class reference: {" + classNameInLibrary + "} in swf {" + libraryName + "} was found"));
		}
		
		/**
		 * Get a movie clip from the library of a loaded swf asset.
		 * 
		 * @param	libraryName			The library name used when the asset was registered.
		 * @param	classNameInLibrary	The class name in the loaded swf's library.
		 * @return 	MovieClip			Returns the asset as a MovieClip
		 */
		public function getMovieClipFromSWFLibrary(libraryName:String, classNameInLibrary:String):MovieClip
		{
			if(assets[libraryName] != null)
			{
				var swf:Loader = getAsset(libraryName) as Loader;
				var SymbolClassMC:Class = swf.contentLoaderInfo.applicationDomain.getDefinition(classNameInLibrary) as Class;
				var symbolInstance:MovieClip = new SymbolClassMC() as MovieClip;
				return symbolInstance;
			}
			throw(new Error("No movie clip: {" + classNameInLibrary + "} in swf {" + libraryName + "} was found"));
		}
		
		/**
		 * Get a sprite from the library of a loaded swf asset.
		 * 
		 * @param	libraryName		The library name used when the asset was registered.
		 * @param	classNameInLibrary		The class name in the loaded swf's library.
		 * @return	Sprite		Returns the asset as a MovieClip
		 */
		public function getSpriteFromSWFLibrary(libraryName:String, classNameInLibrary:String):Sprite
		{
			if(assets[libraryName] != null)
			{
				var swf:Loader = getAsset(libraryName) as Loader;
				var SymbolClassMC:Class = swf.contentLoaderInfo.applicationDomain.getDefinition(classNameInLibrary) as Class;
				var symbolInstance:Sprite = new SymbolClassMC() as Sprite;
				return symbolInstance;
			}
			throw(new Error("No sprite: {" + classNameInLibrary + "} in swf {" + libraryName + "} was found"));
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
			if(assets[libraryName] != null)
			{
				var swf:Loader = getAsset(libraryName) as Loader;
				var FontClass:Class = swf.contentLoaderInfo.applicationDomain.getDefinition(fontLinkageId) as Class;
				Font.registerFont(FontClass);
				var fontInstance:Font = new FontClass();
				return fontInstance;
			}
			throw(new Error("No font: {" + fontLinkageId + "} in swf {" + libraryName + "} was found"));
		}
		
		/**
		 * Get a bitmap from a swf library.
		 * 
		 * @param	libraryName		The library name used when the asset was registered.
		 * @param	bitmapLinkageId		The bitmaps linkage Id.
		 * @return 	Bitmap	Returns a Font instance.
		 */
		public function getBitmapFromSWFLibrary(libraryName:String, bitmapLinkageId:String):Bitmap
		{
			if(assets[libraryName] != null)
			{
				var swf:Loader = getAsset(libraryName) as Loader;
				var FontClass:Class = swf.contentLoaderInfo.applicationDomain.getDefinition(bitmapLinkageId) as Class;
				Font.registerFont(FontClass);
				var fontInstance:Bitmap = new FontClass();
				return fontInstance;
			}
			throw(new Error("No bitmap: {" + bitmapLinkageId + "} in swf {" + libraryName + "} was found"));
		}
		
		/**
		 * Get a bitmap from a swf library.
		 * 
		 * @param	libraryName		The library name used when the asset was registered.
		 * @param	soundLinkageId	The sounds linkage id from the library.
		 * @return 	Sound	Returns a Sound instance.
		 */
		public function getSoundFromSWFLibrary(libraryName:String, soundLinkageId:String):Sound
		{
			if(assets[libraryName] != null)
			{
				var swf:Loader = getAsset(libraryName) as Loader;
				var FontClass:Class = swf.contentLoaderInfo.applicationDomain.getDefinition(soundLinkageId) as Class;
				Font.registerFont(FontClass);
				var fontInstance:Sound = new FontClass();
				return fontInstance;
			}
			throw(new Error("No sound: {" + soundLinkageId + "} in swf {" + libraryName + "} was found"));
		}
		
		/**
		 * Get a loaded asset as a Bitmap.
		 * 
		 * @param	libraryName		The library name used when the asset was registered.
		 * @return	Bitmap			returns a flash.display.Bitmap asset.
		 */
		public function getBitmap(libraryName:String):Bitmap
		{
			if(assets[libraryName] != null) return Bitmap(getAsset(libraryName).content);
			throw new Error("Bitmap {" + libraryName + "} was not found");
		}
		
		/**
		 * Get a Sound asset.
		 * 
		 * @param	libraryName		The library name used when the asset was registered.
		 * @return	Sound	returns a flash.media.Sound instance.
		 */
		public function getSound(libraryName:String):Sound
		{
			if(assets[libraryName] != null) return getAsset(libraryName) as Sound;
			throw new Error("Sound {" + libraryName + "} was not found");
		}
		
		/**
		 * Get an FZip asset.
		 * 
		 * @param	libraryName		The library name used when the asset was registered.
		 * @return	FZip
		 */
		public function getFZip(libraryName:String):FZip
		{
			if(assets[libraryName] != null) return getAsset(libraryName) as FZip;
			throw new Error("FZip {" + libraryName + "} was not found.");
		}
		
		/*
		 * Get a Bitmap from inside of a zip file.
		 * 
		 * @param		String		The libraryName used to register the target zip file.
		 * @param		String		The file in the zip to grab		
		 */
		/*public function getBitmapFromFZip(fzipItemID:String, filenameInZip:String):Bitmap
		{
			if(assets[fzipItemID] != null)
			{
				var fzip:FZip = FZip(assets[fzipItemID]);
				var file:FZipFile = fzip.getFileByName(filenameInZip);
				return Bitmap(file.fileContent);
			}
			throw new Error("FZip item {" + fzipItemID + "} was not found.");
		}*/

		/**
		 * Purge all assets from the library.
		 */
		public function dispose():void
		{
			assets = new Dictionary(true);
		}
	}
}