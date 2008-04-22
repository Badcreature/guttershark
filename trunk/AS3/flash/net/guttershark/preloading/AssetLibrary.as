package net.guttershark.preloading
{
	
	import flash.display.Bitmap;	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.utils.Dictionary;	
	
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
	public class AssetLibrary
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
		 * Get a movie clip from the library of a loaded swf asset.
		 * 
		 * @param	libraryName			The library name used when the asset was registered.
		 * @param	classNameInLibrary	The class name in the loaded swf's library.
		 * @return 	MovieClip			Returns the asset as a MovieClip
		 */
		public function getAssetFromSWFLibraryAsMovieClip(libraryName:String, classNameInLibrary:String):MovieClip
		{
			if(assets[libraryName] != null)
			{
				var swf:Loader = getAsset(libraryName) as Loader;
				var SymbolClassMC:Class = swf.contentLoaderInfo.applicationDomain.getDefinition(classNameInLibrary) as Class;
				var symbolInstance:MovieClip = new SymbolClassMC() as MovieClip;
				return symbolInstance;
			}
			throw(new Error("No asset: {" + classNameInLibrary + "} in swf {" + libraryName + "} was found"));
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
		public function purge():void
		{
			assets = new Dictionary(true);
		}
	}
}