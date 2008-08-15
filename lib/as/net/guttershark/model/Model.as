package net.guttershark.model 
{
	import flash.net.URLRequest;
	
	import net.guttershark.errors.AssertError;
	import net.guttershark.preloading.Asset;
	import net.guttershark.remoting.RemotingManager;
	import net.guttershark.services.ServiceManager;
	import net.guttershark.util.Assert;
	import net.guttershark.util.StringUtils;		

	/**
	 * The Model class provides shortcuts for parsing a default model xml file,
	 * and provides shortcut methods for common operations.
	 * 
	 * @example Example model XML file:
	 * <listing>	
	 * &lt;?xml version="1.0" encoding="utf-8"?&gt;
	 * &lt;model&gt;
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
	 *    &lt;links&gt;
	 *        &lt;link id="google" url="http://www.google.com" /&gt;
	 *        &lt;link id="rubyamf" url="http://www.rubyamf.org" /&gt;
	 *        &lt;link id="guttershark" url="http://www.guttershark.net" window="_blank" /&gt;
	 *    &lt/links&gt;
	 *    &lt;attributes&gt;
	 *        &lt;attribute id="host" value="http://www.guttershark.net" /&gt;
	 *    &lt;/attributes&gt;
	 * &lt;/model&gt;
	 * </listing>
	 */
	dynamic public class Model
	{
		
		/**
		 * singleton instance
		 */
		protected static var instance:Model;
		
		/**
		 * Reference to the entire site XML file.
		 */
		protected var _model:XML;
		
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
		 * Stores a reference to the <code>&lt;http&gt;&lt;/http&gt;</code> node.
		 */
		protected var http:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;links&gt;&lt;/links&gt;</code> node.
		 * 
		 * @example A links node set.
		 * <listing>
		 * &lt;links&gt;
	 	 *     &lt;link id="google" url="http://www.google.com" /&gt;
	 	 *     &lt;link id="rubyamf" url="http://www.rubyamf.org" /&gt;
	 	 *     &lt;link id="guttershark" url="http://www.guttershark.net" /&gt;
	 	 * &lt/links&gt;
		 * </listing>
		 */
		protected var links:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;attributes&gt;&lt;/attributes&gt;</code> node.
		 * 
		 * @example An attributes node set.
		 * &lt;attributes&gt;
	 	 *     &lt;attribute id="host" value="http://www.guttershark.net" /&gt;
	 	 * &lt;/attributes&gt;
		 */
		protected var attributes:XMLList;
		
		/**
		 * The flash movies' flashvars.
		 */
		public var flashvars:Object;
		
		/**
		 * @private
		 * Constructor for Model instances.
		 */
		public function Model()
		{
			if(Model.instance) throw new Error("Model is a singleton, please see Model.gi()");
		}
		
		/**
		 * Singleton access.
		 */
		public static function gi():Model
		{
			if(instance == null) instance = new Model();
			return instance;
		}
		
		/**
		 * Set the model XML file on the singleton instance.
		 */
		public function set xml(xml:XML):void
		{
			Assert.NotNull(xml, "Parameter xml cannot be null");
			_model = xml;
			if(_model.assetPaths) assetPaths = _model.assetPaths;
			if(_model.assets) assets = _model.assets;
			if(_model.preload) preload = _model.preload;
			if(_model.links) links = _model.links;
			if(_model.services)
			{
				if(_model.services.remoting) remoting = _model.services.remoting;
				if(_model.services.http) http = _model.services.http;
			}
			if(_model.attributes) attributes = _model.attributes;
		}
		
		/**
		 * Get the internal model XML file.
		 */
		public function get xml():XML
		{
			return _model;
		}
		
		/**
		 * Utility method for finding file types from source paths.
		 */
		public function findFileType(source:String):String
		{
			var fileType:String = StringUtils.FindFileType(source);
			if(!fileType) throw new Error("Filetype could not be found.");
			return fileType;
		}
		
		/**
		 * Prepend the correct path for an asset.
		 * 
		 * <p>You can pass in a filename, like: "myfile.jpg", and it will
		 * return a new string like: "assets/bmp/myfile.jpg".</p>
		 * 
		 * <p>It concatenates the "basePath"+"typePath"+file</p>
		 */
		public function prependAssetPath(source:String):String
		{
			Assert.NotNull(source, "Parameter source cannot be null");
			if(!assetPaths) throw new Error("The assetPath node is not defined");
			var fileType:String = findFileType(source);
			var path:String;
			switch(fileType)
			{
				case "jpg":
				case "jpeg":
				case "bmp":
				case "png":
				case "gif":
					if(assetPaths.bitmapPath == undefined) throw new Error("The bitmapPath node is not defined within the assetPaths node.");
					path = assetPaths.bitmapPath.toString();
					break;
				case "swf":
					if(assetPaths.swfPath == undefined) throw new Error("The swfPath node is not defined within the assetPaths node.");
					path = assetPaths.swfPath.toString();
					break;
				case "mp3":
					if(assetPaths.soundPath == undefined) throw new Error("The soundPath node is not defined within the assetPaths node.");
					path = assetPaths.soundPath.toString();
					break;
				case "flv":
					if(assetPaths.flvPath == undefined) throw new Error("The flvPath node is not defined within the assetPaths node.");
					path = assetPaths.flvPath.toString();
					break;
				case "xml":
					if(assetPaths.xmlPath == undefined) throw new Error("The xmlPath node is not defined within the assetPaths node.");
					path = assetPaths.xmlPath.toString();
					break;
			}
			source = assetPaths.@basePath + path + source;
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
			checkForXML();
			var assetsToLoad:Array = [];
			for each(var ast:XML in _model.preload.asset)
			{
				var asset:XMLList = assets.asset.(@libraryName == ast.@libraryName);
				var source:String = prependAssetPath(asset.@source);
				assetsToLoad.push(new Asset(source, asset.@libraryName));
			}
			return assetsToLoad;
		}
		
		/**
		 * Get an Asset instance by the library name.
		 * 
		 * @param	libraryName	The libraryName of the asset to create.
		 * @param	prependAssetPaths	Whether or not to automatically prepend asset paths, based on nodes from XML.
		 * @return	An instance of an Asset.
		 */
		public function getAssetByLibraryName(libraryName:String, prependAssetPaths:Boolean = true):Asset
		{
			checkForXML();
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			var node:XMLList = assets..asset.(@libraryName == libraryName);
			var ft:String = (node.@forceType != undefined && node.@forceType != "") ? node.@forceType : null;
			var s:String = (prependAssetPaths) ? prependAssetPath(node.@source) : node.@source;
			return new Asset(s,libraryName,ft);
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
			checkForXML();
			Assert.NotNull(remoting, "No remoting nodes were found. Please define them in the services node.");
			Assert.NotNull(endpointID, "Parameter id cannot be null");
			var endpoint:XMLList = remoting.endpoint.(@id == endpointID);
			if(!endpoint) throw new Error("Endpoint " + endpointID + " could not be found.");
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
		
		/**
		 * Initialize http service for a specific service id. Uses the supplied service manager.
		 * 
		 * @param	serviceID	The service id.
		 * @param	serviceManager	The service manager that will house the services.
		 */
		public function initializeHTTPService(serviceID:String,serviceManager:ServiceManager):void
		{
			checkForXML();
			Assert.NotNull(serviceID, "Parameter serviceID cannot be null");
			Assert.NotNull(serviceManager, "Parameter serviceManager cannot be null");
			var service:XMLList = http.service.(@id == serviceID);
			serviceManager.createService(serviceID,service.@url,service.@defaultResponseFormat);
		}

		/**
		 * Creates and returns a URLRequest from a link node.
		 * @param	id	The id of the link node.
		 * @return	URLRequest
		 */
		public function getLink(id:String):URLRequest
		{
			checkForXML();
			var link:XMLList = links..link.(@id == id);
			if(!link) return null;
			var u:URLRequest = new URLRequest(link.@url);
			return u;
		}
		
		/**
		 * Get the window attribute value on a link node.
		 * @param	id	The id of the link node.
		 * @return	String
		 */
		public function getLinkWindow(id:String):String
		{
			checkForXML();
			var link:XMLList = links..link.(@id == id);
			if(!link) return null;
			return link.@window;
		}
		
		/**
		 * Get the value from an attribute node.
		 * @param	attributeID	The id of an attribute node.
		 */
		public function getAttribute(attributeID:String):String
		{
			var attr:XMLList = attributes..attribute.(@id == attributeID);
			if(!attr) return null;
			return attr.@value;
		}
		
		/**
		 * Check that the siteXML was set on the singleton instance before any attempts
		 * to read the siteXML variable happen.
		 */
		protected function checkForXML():void
		{
			Assert.NotNull(_model, "The model xml must be set on the model before attempting to read a property from it.",AssertError);
		}
	}
}