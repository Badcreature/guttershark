package net.guttershark.model 
{
	import flash.external.ExternalInterface;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import net.guttershark.managers.ServiceManager;
	import net.guttershark.support.preloading.Asset;
	import net.guttershark.util.Assertions;
	import net.guttershark.util.Singleton;
	import net.guttershark.util.Utilities;
	import net.guttershark.util.cache.Cache;		

	/**
	 * The Model Class provides shortcuts for parsing a model xml file as
	 * well as other model centric methods.
	 * 
	 * @example Example model XML file:
	 * <listing>	
	 * &lt;?xml version="1.0" encoding="utf-8"?&gt;
	 * &lt;model&gt;
	 *    &lt;assets&gt;
	 *        &lt;asset libraryName="clayBanner1" source="clay_banners_1.jpg" preload="true" /&gt;
	 *        &lt;asset libraryName="clayBanner2" source="clay_banners_2.jpg" /&gt;
	 *        &lt;asset libraryName="clayWebpage" source="clay_webpage.jpg" /&gt;
	 *    &lt;/assets&gt;
	 *    &lt;links&gt;
	 *        &lt;link id="google" url="http://www.google.com" /&gt;
	 *        &lt;link id="rubyamf" url="http://www.rubyamf.org" /&gt;
	 *        &lt;link id="guttershark" url="http://www.guttershark.net" window="_blank" /&gt;
	 *    &lt/links&gt;
	 *    &lt;attributes&gt;
	 *        &lt;attribute id="someAttribute" value="the value" /&gt;
	 *    &lt;/attributes&gt;
	 *    &lt;services&gt;
	 *        &lt;gateway id="amfphp" path="amfphp" url="http://localhost/amfphp/gateway.php" objectEncoding="3" /&gt;
	 *        &lt;service id="test" gateway="amfphp" endpoint="Test" limiter="true" attempts="4" timeout="1000" /&gt;
	 *        &lt;service id="foo" url="http://localhost/" attempts="4" timeout="1000" /&gt;
	 *        &lt;service id="sessionDestroy" path="sessiondestroy" url="http://tagsf/services/codeigniter/session/destroy" attempts="4" timeout="1000" responseFormat="variables" /&gt;
	 *        &lt;service id="ci" url="http://tagsf/services/codeigniter/" attempts="4" timeout="1000" responseFormat="variables" /&gt;
	 *    &lt;/services&gt;
	 *    &lt;stylesheets&gt;
	 *        &lt;stylesheet id="colors"&gt;
	 *        &lt;![CDATA[
	 *            .pink{color:#FF0066}
	 *        ]]&gt;
	 *        &lt;/stylesheet&gt;
	 *    &lt;/stylesheets&gt;
	 *    &lt;textformats&gt;
	 *        &lt;textformat id="theTF" font="Arial" color="0xFF0066" bold="true" /&gt;
	 *    &lt;/textformats&gt;
	 * &lt;/model&gt;
	 * </listing>
	 */
	final public class Model
	{
		
		/**
		 * Singleton instance.
		 */
		protected static var inst:Model;
		
		/**
		 * Reference to the entire model XML.
		 */
		private var _model:XML;
		
		/**
		 * Stores a reference to the &lt;assets&gt;&lt;/assets&gt;
		 * node in the model xml.
		 */
		protected var assets:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;links&gt;&lt;/links&gt;</code>
		 * node in the model xml.
		 */
		protected var links:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;attributes&gt;&lt;/attributes&gt;</code>
		 * node in the model xml.
		 */
		protected var attributes:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;services&gt;&lt;/services&gt;</code>
		 * node in the model xml.
		 */
		protected var services:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;stylesheets&gt;&lt;/stylesheets&gt;</code>
		 * node in the model xml.
		 */
		protected var stylesheets:XMLList;
		
		/**
		 * Stores a reference to the <code>&lt;textformats&gt;&lt;/textformats&gt;</code>
		 */
		protected var textformats:XMLList;
		
		/**
		 * A placeholder variable for the movies flashvars - this is
		 * not set by default, you need to set it in your controller.
		 */
		public var flashvars:Object;
		
		/**
		 * A placeholder variable for the movies shared object - this is
		 * not set by default, override <em><code>restoreSharedObject</code></em>
		 * in your DocumentController, and set this property to a shared object.
		 * 
		 * @see net.guttershark.control.DocumentController#restoreSharedObject() restoreSharedObject method.
		 */
		public var sharedObject:SharedObject;
		
		/**
		 * Assertions.
		 */
		private var ast:Assertions;

		/**
		 * If external interface is not available, all paths are stored here.
		 */
		private var paths:Dictionary;
		
		/**
		 * ExternalInterface availability flag.
		 */
		private var available:Boolean;
		
		/**
		 * Flag for warning about ExternalInterface.
		 */
		private var warnedAboutEI:Boolean;
		
		/**
		 * Utilities singleton instance.
		 */
		private var utils:Utilities;
		
		/**
		 * A cache for text formats and stylesheets.
		 */
		private var formatcache:Cache;

		/**
		 * @private
		 * Constructor for Model instances.
		 */
		public function Model()
		{
			Singleton.assertSingle(Model);
			paths = new Dictionary();
			ast = Assertions.gi();
			utils = Utilities.gi();
			formatcache = new Cache();
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
		 * sets the model xml
		 */
		public function set xml(xml:XML):void
		{
			ast.notNil(xml, "Parameter xml cannot be null");
			_model = xml;
			if(_model.assets) assets = _model.assets;
			if(_model.links) links = _model.links;
			if(_model.attributes) attributes = _model.attributes;
			if(_model.stylesheets) stylesheets = _model.stylesheets;
			if(_model.service) services = _model.services;
			if(_model.textformats) textformats = _model.textformats;
		}
		
		/**
		 * The XML used as the model.
		 */
		public function get xml():XML
		{
			return _model;
		}
		
		/**
		 * Get an Asset instance by the library name.
		 * 
		 * @param libraryName The libraryName of the asset to create.
		 * @param prependSourcePath	The path to append to the source property of the asset.
		 */
		public function getAssetByLibraryName(libraryName:String, prependSourcePath:String = null):Asset
		{
			checkForXML();
			ast.notNil(libraryName, "Parameter libraryName cannot be null");
			var node:XMLList = assets..asset.(@libraryName == libraryName);
			var ft:String = (node.@forceType != undefined && node.@forceType != "") ? node.@forceType : null;
			var s:String = (prependSourcePath) ? prependSourcePath+node.@source : node.@source;
			if(node.@path != undefined) s = getPath(node.@path.toString()) + node.@source.toString();
			return new Asset(s,libraryName,ft);
		}
		
		/**
		 * Initializes all services defined in the model XML with the ServiceManager.
		 */
		public function initServices():void
		{
			var sm:ServiceManager = ServiceManager.gi();
			var children:XMLList = xml.services.service;
			var oe:int = 3;
			var gateway:String;
			var attempts:int = 1;
			var timeout:int = 10000;
			var limiter:Boolean = false;
			var url:String;
			var drf:String;
			for each(var s:XML in children)
			{
				if(s.@attempts != undefined) attempts = int(s.@attempts);
				if(s.@timeout != undefined) timeout = int(s.@timeout);
				if(s.@limiter != undefined && s.@limiter=="true") limiter = true;
				if(s.@gateway != undefined)
				{
					var r:XMLList = xml.services.gateway.(@id == s.@gateway);
					var username:String;
					var password:String;
					if(!r) throw new Error("Gateway {"+s.@gateway+"} not found.");
					if(r.@password !=undefined && (r.@username != undefined || r.@userid !=undefined))
					{
						username = (r.@username!=undefined) ? r.@username : r.@userid;
						password = r.@password;
					}
					if(r.@url != undefined) gateway = r.@url;
					if(r.@path != undefined) gateway = getPath(r.@path.toString());
					if(!gateway) throw new Error("Gateway not found, you must have a url or path attribute on defined on the gateway node.");
					if(r.@objectEncoding!=undefined) oe = int(r.@objectEncoding);
					if(oe != 3 && oe != 0) throw new Error("ObjectEncoding can only be 0 or 3.");
					sm.createRemotingService(s.@id,gateway,s.@endpoint,oe,attempts,timeout,limiter,true,username,password);
				}
				else
				{
					if(s.@url != undefined) url = s.@url;
					if(s.@path != undefined) url = getPath(s.@path.toString());
					if(s.@responseFormat != undefined) drf = s.@responseFormat;
					if(drf != null && drf != "variables" && drf != "xml" && drf != "text" && drf != "binary") throw new Error("The defined response format is not supported, only xml|text|binary|variables is supported.");
					sm.createHTTPService(s.@id, url, attempts, timeout, limiter, drf);
				}
			}
		}
		
		/**
		 * Returns an array of Asset instances from the assets node,
		 * that has a "preload" attribute set to true (preload='true').
		 */
		public function getAssetsForPreload():Array
		{
			var a:XMLList = assets..asset;
			if(!a)
			{
				trace("WARNING: No assets were defined, not doing anything.");
				return null;
			}
			var payload:Array = [];
			for each(var n:XML in a)
			{
				if(!n.attribute("preload")) continue;
				var src:String = n.@source;
				if(n.attribute("path")!=undefined) src = getPath(n.@path) + src;
				var ast:Asset = new Asset(src,n.@libraryName);
				payload.push(ast);
			}
			return payload;
		}

		/**
		 * Creates and returns a URLRequest from a link node.
		 * 
		 * @param id The id of the link node.
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
		 * @param id The id of the link node.
		 */
		public function getLinkWindow(id:String):String
		{
			checkForXML();
			var link:XMLList = links..link.(@id == id);
			if(!link) return null;
			return link.@window;
		}
		
		/**
		 * Navigates to a link.
		 * 
		 * @param id The link id.
		 */
		public function navigateToLink(id:String):void
		{
			var req:URLRequest = getLink(id);
			var w:String = getLinkWindow(id);
			navigateToURL(req,w);
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
			if(utils.player.isIDEPlayer() || utils.player.isStandAlonePlayer())
			{
				if(!warnedAboutEI)
				{
					trace("WARNING: ExternalInterface is not available, path logic will use internal dictionary.");
					warnedAboutEI = true;
				}
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
			ast.notNil(_model, "The model xml must be set on the model before attempting to read a property from it. Please see documentation in the DocumentController for the flashvars.model and flashvars.autoInitModel property.",Error);
		}

		/**
		 * Check whether or not a path has been defined.
		 */
		public function isPathDefined(path:String):Boolean
		{
			checkEI();
			if(!available) return !(paths[path]==false);
			return ExternalInterface.call("net.guttershark.Paths.isPathDefined",path);
		}
		
		/**
		 * Add a URL path to the model - if ExternalInterface is available, it
		 * uses the guttershark javascript api. Otherwise it's stored in a local dictionary.
		 * 
		 * @example Using path logic with the model.
		 * <listing>
		 * public class Main extends DocumentController
		 * {
		 * 
		 *     //only called in standalone player, otherwise you must
		 *     //add paths through javascript - see the guttershark/lib/js/guttershark.js file.
		 *     override protected function initPathsForStandalone():void
		 *     {
		 *         ml.addPath("root","./");
		 *         ml.addPath("assets",ml.getPath("root")+"assets/");
		 *         ml.addPath("bitmaps",ml.getPath("root","assets")+"bitmaps/");
		 *         testPaths();
		 *     }
		 *     
		 *     //illustrates how the "getPath" function works.
		 *     private function testPaths():void
		 *     {
		 *         trace(ml.getPath("root")); // -> ./
		 *         trace(ml.getPath("assets")); // -> ./assets/
		 *         trace(ml.getPath("bitmaps")); // -> ./assets/bitmaps/
		 *     }
		 * }
		 * </listing>
		 * 
		 * @param pathId The path identifier.
		 * @param path The path.
		 */	
		public function addPath(pathId:String, path:String):void
		{
			checkEI();
			if(!available)
			{
				paths[pathId]=path;
				return;
			}
			ExternalInterface.call("net.guttershark.Paths.addPath",pathId,path);
		}
		
		/**
		 * Get a path concatenated from the given pathIds - if ExternalInterface is
		 * available, it uses the guttershark javascript api. Otherwise it's stored in a local
		 * dictionary.
		 * 
		 * 
		 * @param ...pathIds An array of pathIds whose values will be concatenated together.
		 * 
		 * @see #addPath() addPath function.
		 */
		public function getPath(...pathIds:Array):String
		{
			checkEI();
			var fp:String = "";
			if(!available)
			{
				var i:int = 0;
				var l:int = pathIds.length;
				for(i;i<l;i++)
				{
					if(!paths[pathIds[i]]) throw new Error("Path {"+pathIds[i]+"} not defined.");
					fp += paths[pathIds[i]];
				}
				return fp;
			}
			return ExternalInterface.call("net.guttershark.Paths.getPath",pathIds as Array);
		}
		
		/**
		 * Get a StyleSheet object by the node id.
		 * 
		 * @param id The id of the stylesheet node to grab from the model.
		 */
		public function getStyleSheetById(id:String):StyleSheet
		{
			var cacheId:String = "css_"+id;
			if(formatcache.isCached(cacheId)) return formatcache.getCachedObject(cacheId);
			var n:XMLList = stylesheets.stylesheet.(@id==id);
			if(!n) return null;
			var s:StyleSheet = new StyleSheet();
			s.parseCSS(n.toString());
			formatcache.cacheObject(cacheId,s);
			return s;
		}
		
		/**
		 * Get a TextFormat object by the node id.
		 * 
		 * <p>Supports these attributes:</p>
		 * <ul>
		 * <li>align</li>
		 * <li>blockIndent</li>
		 * <li>bold</li>
		 * <li>bullet</li>
		 * <li>color</li>
		 * <li>font</li>
		 * <li>indent</li>
		 * <li>italic</li>
		 * <li>kerning</li>
		 * <li>leading</li>
		 * <li>leftMargin</li>
		 * <li>letterSpacing</li>
		 * <li>rightMargin</li>
		 * <li>size</li>
		 * <li>underline</li>
		 * </ul>
		 */
		public function getTextFormatById(id:String):TextFormat
		{
			var cacheId:String = "tf_"+id;
			if(formatcache.isCached(cacheId)) return formatcache.getCachedObject(cacheId) as TextFormat;
			var n:XMLList = textformats.textformat.(@id==id);
			var tf:TextFormat = new TextFormat();
			if(n.attribute("align")!=undefined) tf.align = n.@align;
			if(n.attribute("blockIndent")!=undefined) tf.blockIndent = int(n.@blockIndent);
			if(n.attribute("bold")!=undefined) tf.bold = n.@bold;
			if(n.attribute("bullet")!=undefined) tf.bullet = utils.string.toBoolean(n.@bullet);
			if(n.attribute("color")!=undefined) tf.color = Number(n.@color);
			if(n.attribute("font")!=undefined) tf.font = n.@font;
			if(n.attribute("indent")!=undefined) tf.indent = int(n.@indent);
			if(n.attribute("italic")!=undefined) tf.italic = utils.string.toBoolean(n.@italic);
			if(n.attribute("kerning")!=undefined) tf.kerning = utils.string.toBoolean(n.@kerning);
			if(n.attribute("leading")!=undefined) tf.leading = int(n.@leading);
			if(n.attribute("leftMargin")!=undefined) tf.leftMargin = int(n.@leftMargin);
			if(n.attribute("letterSpacing")!=undefined) tf.letterSpacing = int(n.@letterSpacing);
			if(n.attribute("rightMargin")!=undefined) tf.rightMargin = int(n.@rightMargin);
			if(n.attribute("size")!=undefined) tf.size = int(n.@size);
			if(n.attribute("underline")!=undefined) tf.underline = utils.string.toBoolean(n.@underline);
			formatcache.cacheObject(cacheId,tf);
			return tf;
		}

		/**
		 * Flush the <em><code>sharedObject</code></em> property.
		 */
		public function flushSharedObject():void
		{
			if(!sharedObject)
			{
				trace("WARNING: sharedObject was not flushed, it is null.");
				return;
			}
			sharedObject.flush();
		}
	}
}