package net.guttershark.model 
{
		
	import net.guttershark.remoting.RemotingManager;	
	import net.guttershark.util.StringUtils;	
	import net.guttershark.preloading.Asset;	
	import net.guttershark.util.Assert;

	/**
	 * The SiteXMLParser class provides shortcuts for parsing a default site xml file.
	 * 
	 * <p>A default implementation of a site xml file contains information for preloading and
	 * some optional elements.</p>
	 * 
	 * <p>It includes at least these nodes:</p>
	 * <ul>
	 * <li>An <code><em>assetPath</em></code> node, with sub nodes defining paths for specific media types.</li>
	 * <li>An <code><em>assets</em></code> node, with <code><em>asset</em></code> sub nodes. These define all assets that
	 * potentially need to be preloaded.</li>
	 * <li>A <code><em>preload</em></code> node, with <code><em>asset</em></code> sub nodes. These asset sub nodes correlate
	 * directly to a node in the <code><em>assets</em></code> node, essentially this preload node defines references
	 * to other assets from the assets pool node.</li>
	 * </ul>
	 * 
	 * <p>With optional nodes:</p>
	 * <ul>
	 * <li>A <code><em>services</em></code> node.</li>
	 * </ul>
	 * 
	 * @example A default site XML file:
	 * <listing>	
	 * &lt;?xml version="1.0" encoding="utf-8"?&gt;
	 * &lt;site&gt;
	 *    &lt;assetPaths basePath="assets/"&gt;
	 *        &lt;bitmapPath&gt;bmp/&lt;/bitmapPath&gt;
	 *        &lt;soundPath&gt;sounds/&lt;/soundPath&gt;
	 *        &lt;swfPath&gt;swf/&lt;/swfPath&gt;
	 *        &lt;flvPath&gt;flv/&lt;/flvPath&gt;
	 *        &lt;xmlPath&gt;xml/&lt;/xmlPath&gt;
	 *    &lt;/assetPaths&gt;
	 *    &lt;assets&gt;
	 *        &lt;asset libraryName="clayBanner1" source="clay_banners_1.jpg" /&gt;
	 *        &lt;asset libraryName="clayBanner2" source="clay_banners_2.jpg" /&gt;
	 *        &lt;asset libraryName="clayWebpage" source="clay_webpage.jpg" /&gt;
	 *    &lt;/assets&gt;
	 *    &lt;preload&gt;
	 *       &lt;asset libraryName="clayBanner1" /&gt;
	 *       &lt;asset libraryName="clayBanner2" /&gt;
	 *       &lt;asset libraryName="clayWebpage" /&gt;
	 *    &lt;/preload&gt;
	 *    &lt;!-- OPTIONAL ELEMENTS --&gt;
	 *    &lt;services&gt;
	 *       &lt;remoting&gt;
	 *          &lt;endpoint id="amfphp" gateway="http://localhost/amfphp/gateway.php" useLimiter="true" maxRetries="5" callTimeout="5000" objectEncoding="3"&gt;
	 *             &lt;service id="amfphp_service1" useCache="false" cacheExpireTimeout="-1"&gt;com.myphp.Service1&lt;/service&gt;
	 *             &lt;service id="amfphp_service2" useCache="false" cacheExpireTimeout="-1"&gt;com.myphp.Service2&lt;/service&gt;
	 *          &lt;/endpoint&gt;
	 *          &lt;endpoint id="rubyamf" gateway="http://localhost/rubyamf/gateway.php" useLimiter="true" maxRetries="5" callTimeout="5000" objectEncoding="3"&gt;
	 *             &lt;service id="rubyamf_service1" useCache="false" cacheExpireTimeout="-1"&gt;com.myphp.Service1&lt;/service&gt;
	 *             &lt;service id="rubyamf_service2" useCache="false" cacheExpireTimeout="-1"&gt;com.myphp.Service2&lt;/service&gt;
	 *          &lt;/endpoint&gt;
	 *       &lt;/remoting&gt;
	 *    &lt;/services&gt;
	 * &lt;/site&gt;
	 * </listing>
	 */
	dynamic public class SiteXMLParser
	{
		
		/**
		 * Reference to the entire site XML file.
		 */
		protected var siteXML:XML;
		
		/**
		 * Stores a reference to the &lt;assetPaths&gt;&lt;/assetPaths&gt; node.
		 * 
		 * @example An assetPath node:
		 * <listing>	
		 * &lt;assetPaths basePath="assets/"&gt;
		 *    &lt;bitmapPath&gt;bmp/&lt;/bitmapPath&gt;
		 *    &lt;soundPath&gt;sounds/&lt;/soundPath&gt;
		 *    &lt;swfPath&gt;swf/&lt;/swfPath&gt;
		 *    &lt;flvPath&gt;flv/&lt;/flvPath&gt;
		 * &lt;/assetPaths&gt;
		 * </listing>
		 */
		protected var assetPaths:XMLList;
		
		/**
		 * Stores a reference to the &lt;preload&gt;&lt;/preload&gt; node.
		 * 
		 * @example A preload node.
		 * <listing>	
		 * &lt;preload&gt;
		 *     &lt;asset libraryName="test1" /&gt;
		 * &lt;/preload&gt;
		 * </listing>
		 * 
		 * <p>In the above example, the <code>asset</code> node will correlate directly
		 * to another node in the <code>assets</code> nodes with the same libraryName. 
		 * The libraryName is used as a lookup id into the <code>assets</code> nodes.</p>
		 */
		protected var preload:XMLList;
		
		/**
		 * Stores a reference to the &lt;assets&gt;&lt;/assets&gt; node.
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
		 */
		protected var assets:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;remoting&gt;&lt;/remoting&gt;</code> node.
		 * 
		 * @example A remoting nodes set.
		 * <listing>	
		 * &lt;services&gt;
		 *     &lt;remoting&gt;
		 *         &lt;endpoint id="amfphp" gateway="http://localhost/amfphp/gateway.php" useLimiter="true" useCache="true" maxRetries="5" callTimeout="5000" objectEncoding="3"&gt;
		 *             &lt;service id="amfphp_service1" useCache="false" cacheExpireTimeout="-1"&gt;com.myphp.Service1&lt;/service&gt;
		 *             &lt;service id="amfphp_service2" useCache="false" cacheExpireTimeout="-1"&gt;com.myphp.Service2&lt;/service&gt;
		 *         &lt;/endpoint&gt;
		 *         &lt;endpoint id="rubyamf" gateway="http://localhost/amfphp/gateway.php" useLimiter="true" useCache="true" maxRetries="5" callTimeout="5000" objectEncoding="3"&gt;
		 *             &lt;service id="rubyamf_service1" useCache="false" cacheExpireTimeout="-1"&gt;com.myphp.Service1&lt;/service&gt;
		 *             &lt;service id="rubyamf_service2" useCache="false" cacheExpireTimeout="-1"&gt;com.myphp.Service2&lt;/service&gt;
		 *         &lt;/endpoint&gt;
		 *     &lt;/remoting&gt;
		 * &lt;/services&gt;
		 * </listing>
		 * 
		 * <p>The above attributes in the endpoint node are all the available attributes. Generally you don't need
		 * to specify them on the service level, so they're only available as canvas options for
		 * each service.</p>
		 */
		protected var remoting:XMLList;
		
		/**
		 * Constructor for SiteXMLParser instances.
		 */
		public function SiteXMLParser(siteXML:XML):void
		{
			Assert.NotNull(siteXML, "Parameter siteXML cannot be null");
			this.siteXML = siteXML;
			if(siteXML.assetPaths) assetPaths = siteXML.assetPaths;
			if(siteXML.assets) assets = siteXML.assets;
			if(siteXML.preload) preload = siteXML.preload;
			if(siteXML.services)
			{
				if(siteXML.services.remoting)
				{
					remoting = siteXML.services.remoting;
				}
			}
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
				case "xml":
					path = assetPaths.xmlPath.toString();
					break;
			}
			source = path + source;
			return source;
		}
		
		/**
		 * Creates an Array of Asset instances for preloading with a PreloadController.
		 * 
		 * @return	An array containing Asset instances you can pass directly to a preloadController.addItems() method.
		 * 
		 * @see net.guttershark.preloading.PreloadController#addItems() PreloadController#addItems method.
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
		
		/**
		 * Get an Asset instance by the library name.
		 * 
		 * @param	libraryName	The libraryName of the asset to create.
		 * @return	An instance of an Asset.
		 */
		public function getAssetByLibraryName(libraryName:String):Asset
		{
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			var node:XML = assets..asset.(@libraryName == libraryName);
			return new Asset(node.@source,libraryName);
		}
		
		/**
		 * Initialize remoting services for a specified endpoint, using
		 * the supplied remoting manager.
		 * 
		 * @param	endpointID	The endpoint id.
		 * @param	remotingManager	A remoting manager to intialize services in.
		 */
		public function initializeRemotingEndpoint(endpointID:String, remotingManager:RemotingManager):void
		{
			Assert.NotNull(remoting, "No remoting nodes were found. Please define them in the services node.");
			Assert.NotNull(endpointID, "Parameter id cannot be null");
			var endpoint:XMLList = remoting.endpoint.(@id == endpointID);
			if(!endpoint) throw new Error("Endpoint " + endpointID + "could not be found.");
			RemotingManager.DefaultObjectEncoding = int(endpoint.@objectEncoding);
			var timeout:int = (endpoint.@callTimeout) ? endpoint.@callTimeout : 5000;
			var retries:int = (endpoint.@maxRetries) ? endpoint.@maxRetries : 5;
			var limiter:Boolean;
			if(endpoint.@useLimiter)
			{
				if(endpoint.@useLimiter == "true") limiter = true;
				else limiter = false;
			}
			for each(var service:XML in endpoint.service)
			{
				var cache:Boolean = (service.@useCache == "true") ? true : false;
				var cacheExpire:int = (service.@cacheExpireTimeout) ? int(service.@cacheExpireTimeout) : -1;
				if(service.@id == undefined) throw new Error("<service> nodes must have an \"id\" attribute.");
				remotingManager.createService(service.@id, endpoint.@gateway.toString(),service.toString(),timeout,retries,limiter,cache,cacheExpire);
			}
		}
	}
}