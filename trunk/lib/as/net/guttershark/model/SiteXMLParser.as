package net.guttershark.model 
{
	
	import net.guttershark.util.StringUtils;	
	import net.guttershark.preloading.Asset;	
	import net.guttershark.util.Assert;	

	/**
	 * The SiteXMLParser class provides shortcuts for parsing a
	 * site xml file. This provides methods that work with a
	 * default implementation of a site xml file.
	 */
	public class SiteXMLParser
	{
		
		/**
		 * Reference to the entire site XML file.
		 */
		protected var siteXML:XML;
		
		/**
		 * Stores a reference to the <assetPaths></assetPaths> node.
		 */
		protected var assetPaths:XMLList;
		
		/**
		 * Stores a reference to the <preload></preload> node.
		 * 
		 * @example A preload node.
		 * <listing>
		 * &lt;preload&gt;
		 * &lt;asset libraryName="test1" /&gt;
		 * &lt;/preload&gt;
		 * &lt;/listing&gt;
		 * </listing>
		 * 
		 * <p>In that above example, the <code>asset</code> node will correlate directly
		 * to another node in the <code>assets</code> nodes with the same libraryName. 
		 * The libraryName is used as a lookup id into the <code>assets</code> nodes.</p>
		 */
		protected var preload:XMLList;
		
		/**
		 * Stores a reference to the <assets></assets> node.
		 * 
		 * <p>The assets node is an asset pool that is used in many other places
		 * as a lookup for info about an asset.</p>
		 * 
		 * @example An assets nodes:
		 * <listing>
		 * &lt;assets&gt;
		 *    &lt;asset libraryName="test1" source="test1.jpg" /&gt;
		 *    &lt;asset libraryName="test2" source="test2.jpg" /&gt;
		 *    &lt;asset libraryName="test3" source="test3.jpg" /&gt;
		 * &lt;/assets&gt;
		 * </listing>
		 * 
		 * <p>The above example defines 3 assets.</p>
		 */
		protected var assets:XMLList;
		
		/**
		 * Constructor for SiteXMLParser instances.
		 */
		public function SiteXMLParser(siteXML:XML):void
		{
			Assert.NotNull(siteXML, "Parameter siteXML cannot be null");
			this.siteXML = siteXML;
			assetPaths = siteXML.assetPaths;
			assets = siteXML.assets;
			preload = siteXML.preload;
		}
		
		/**
		 * Utility method for finding file types from source paths.
		 */
		protected function findFileType(source:String):String
		{
			var fileType:String = StringUtils.FindFileType(source);
			if(!fileType) throw new Error("Filetype could not be found.");
			return fileType;
		}
		
		/**
		 * Add the filetype path before the filename.
		 * 
		 * <p>You should pass in a filename, like: "myfile.jpg", and it wil
		 * return a new string like: "bmp/myfile.jpg".</p>
		 */
		protected function prependAssetPath(source:String):String
		{
			var fileType:String = findFileType(source);
			var path:String;
			switch(fileType)
			{
				case "jpg":
				case "jpeg":
				case "bmp":
				case "png":
				case "gif":
					path = assetPaths.bitmapPath.toString();
					break;
				case "swf":
					path = assetPaths.swfPath.toString();
					break;
				case "mp3":
					path = assetPaths.soundPath.toString();
					break;
				case "flv":
					path = assetPaths.flvPath.toString();
					break;
			}
			source = path + source;
			return source;
		}
		
		/**
		 * Get assets to preload.
		 * @return	An array containing Asset instances you can pass directly to a preloadController.addItems() method.
		 */
		public function getAssetsForPreload():Array
		{
			var basePath:String = assetPaths.@basePath;
			var assetsToLoad:Array = [];
			for each(var ast:XML in siteXML.preload.asset)
			{
				var asset:XMLList = assets.asset.(@libraryName == ast.@libraryName);
				var path:String = basePath;
				var source:String = prependAssetPath(asset.@source);
				path += source;
				assetsToLoad.push(new Asset(path, asset.@libraryName));
			}
			return assetsToLoad;
		}
	}
}
