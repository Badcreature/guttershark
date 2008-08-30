package net.guttershark.model 
{
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import net.guttershark.managers.PlayerManager;
	import net.guttershark.managers.ServiceManager;
	import net.guttershark.support.preloading.Asset;
	import net.guttershark.support.servicemanager.remoting.RemotingManager;
	import net.guttershark.util.Assert;
	import net.guttershark.util.Singleton;	

	/**
	 * The Model Class provides shortcuts for parsing a site model xml file as
	 * well as other model centric methods.
	 * 
	 * @example Example model XML file:
	 * <listing>	
	 * &lt;?xml version="1.0" encoding="utf-8"?&gt;
	 * &lt;model&gt;
	 *    &lt;assets&gt;
	 *        &lt;asset libraryName="clayBanner1" source="clay_banners_1.jpg" /&gt;
	 *        &lt;asset libraryName="clayBanner2" source="clay_banners_2.jpg" /&gt;
	 *        &lt;asset libraryName="clayWebpage" source="clay_webpage.jpg" /&gt;
	 *    &lt;/assets&gt;
	 *    &lt;links&gt;
	 *        &lt;link id="google" url="http://www.google.com" /&gt;
	 *        &lt;link id="rubyamf" url="http://www.rubyamf.org" /&gt;
	 *        &lt;link id="guttershark" url="http://www.guttershark.net" window="_blank" /&gt;
	 *    &lt/links&gt;
	 *    &lt;attributes&gt;
	 *        &lt;attribute id="host" value="http://www.guttershark.net" /&gt;
	 *    &lt;/attributes&gt;
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
	 * &lt;/model&gt;
	 * </listing>
	 */
	dynamic public class Model
	{
		
		/**
		 * singleton instance
		 */
		protected static var inst:Model;
		
		/**
		 * Reference to the entire site XML file.
		 */
		protected var _model:XML;
		
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
		 * The flash movies flashvars.
		 */
		public var flashvars:Object;
		
		/**
		 * A SharedObject - use this property on the model, when you 
		 * override the <em><code>restoreSharedObject</code></em> from
		 * the DocumentController.
		 */
		public var sharedObject:SharedObject;

		/**
		 * all paths are stored here, if external interface is not available.
		 */
		private var paths:Dictionary;
		
		/**
		 * ExternalInterface availability flag.
		 */
		private var available:Boolean;

		/**
		 * @private
		 * Constructor for Model instances.
		 */
		public function Model()
		{
			Singleton.assertSingle(Model);
			paths = new Dictionary();
			checkEI();
		}

		/**
		 * Singleton access.
		 */
		public static function gi():Model
		{
			if(!inst) inst = Singleton.gi(Model);
			return inst;
		}
		
		/**
		 * Set the model XML file on the singleton instance.
		 */
		public function set xml(xml:XML):void
		{
			Assert.NotNull(xml, "Parameter xml cannot be null");
			_model = xml;
			if(_model.assets) assets = _model.assets;
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
		 * Get an Asset instance by the library name.
		 * 
		 * @param	libraryName	The libraryName of the asset to create.
		 * @param	prependSourcePath	The path to append to the source property of the asset.
		 * @return	An instance of an Asset.
		 */
		public function getAssetByLibraryName(libraryName:String, prependSourcePath:String):Asset
		{
			checkForXML();
			Assert.NotNull(libraryName, "Parameter libraryName cannot be null");
			var node:XMLList = assets..asset.(@libraryName == libraryName);
			var ft:String = (node.@forceType != undefined && node.@forceType != "") ? node.@forceType : null;
			var s:String = (prependSourcePath) ? prependSourcePath+node.@source : node.@source;
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
		 * 
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
		 * 
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
		 * 
		 * @param	attributeID	The id of an attribute node.
		 */
		public function getAttribute(attributeID:String):String
		{
			var attr:XMLList = attributes..attribute.(@id == attributeID);
			if(!attr) return null;
			return attr.@value;
		}
		
		/**
		 * checks if external interface is available.
		 */	
		private function checkEI():void
		{
			if(PlayerManager.IsIDEPlayer() || PlayerManager.IsStandAlonePlayer())
			{
				trace("WARNING: ExternalInterface is not available, path logic will use internal dictionary.");
				available = false;
				return;
			}
			available = true;
		}
		
		/**
		 * Check that the siteXML was set on the singleton instance before any attempts
		 * to read the siteXML variable happen.
		 */
		protected function checkForXML():void
		{
			Assert.NotNull(_model, "The model xml must be set on the model before attempting to read a property from it. Please see documentation in the DocumentController for the flashvars.model and flashvars.autoInitModel property.",Error);
		}

		/**
		 * Check whether or not a path has been defined.
		 */
		public function isPathDefined(path:String):Boolean
		{
			if(!available) return !(paths[path]==false);
			return ExternalInterface.call("net.guttershark.Paths.isPathDefined",path);
		}
		
		/**
		 * Add a URL Path to the model. If ExternalInterface is available, it
		 * uses the guttershark javascript api. Otherwise everything is
		 * stored in a local dictionary.
		 * 
		 * @param	pathId	The path identifier.
		 * @param	path	The path.
		 */	
		public function addPath(pathId:String, path:String):void
		{
			if(!available)
			{
				paths[pathId]=path;
				return;
			}
			ExternalInterface.call("net.guttershark.Paths.addPath",pathId,path);
		}
		
		/**
		 * Get a path concatenated from the given pathIds. They need
		 * to be in order that you want them concatenated.
		 * 
		 * @param	...pathIds	An array of pathIds whose values will be concatenated together.
		 */
		public function getPath(...pathIds:Array):String
		{
			var fp:String = "";
			if(!available)
			{
				for each(var id:String in pathIds)
				{
					if(!paths[id]) throw new Error("Path {"+id+"} not defined.");
					fp += paths[id];	
				}
				return fp;
			}
			return ExternalInterface.call("net.guttershark.Paths.getPath",pathIds);
		}
	}
}