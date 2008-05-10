package net.guttershark.model 
{
	import net.guttershark.preloading.Asset;	
	import net.guttershark.util.Assert;	

	/**
	 * The SiteXMLParser class provides shortcuts for parsing a
	 * site xml file. This provides methods that work with a
	 * default implentation of a site xml file.
	 */
	public class SiteXMLParser
	{
		
		private var siteXML:XML;
		
		/**
		 * Constructor for SiteXMLParser instances.
		 */
		public function SiteXMLParser(siteXML:XML):void
		{
			Assert.NotNull(siteXML, "The siteXML parameter cannot be null");
			this.siteXML = siteXML;
		}
		
		/**
		 * Get assets to preload from the <preload>..<asset> nodes.
		 * @return	An array containing Asset instances you can pass directly to a preloadController.addItems() method.
		 */
		public function getAssetsForPreloading():Array
		{
			var basePath:String = siteXML.paths.preload.@baseAssetPath;
			var assets:XML = siteXML.preload.asset;
			var assetsToLoad:Array = [];
			for each(var asset:XML in assets)
			{
				var path:String = basePath;
				if(asset.@path) path += asset.@path;
				assetsToLoad.push(new Asset(path + asset.@source, asset.@libraryName));
			}
			return assetsToLoad;
		}
	}
}
