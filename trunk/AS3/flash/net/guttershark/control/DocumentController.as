package net.guttershark.control
{
	
	import flash.net.SharedObject;
	import flash.utils.Dictionary;	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	import net.guttershark.util.QueryString;
	import net.guttershark.util.XMLLoader;
	
	/**
	 * The DocumentController class is the base Document Class for all sites and shell templates
	 * provided in this package. This should always be extended and used as a hook into 
	 * default functionality.
	 * 
	 * <p>The DocumentController provides the following default startup sequence:</p>
	 * <ul>
	 * <li>Read flash vars on the movie.</li>
	 * <ul><li>If the movie was published and running in the Flash IDE. You need to override <code>flashvarsForFlashIDEPublish</code> and provide your own default flashvars.</li></ul>
	 * <li>Load a site xml file. You can specify the name of the xml file to load through the flashvars <code>sitexml</code> property.</li>
	 * <li>Reload a Shared Object, override <code>restoreSharedObject</code>.</li>
	 * <li>Read deeplink data.</li>
	 * <ul><li>If the movie was published and running in the Flash IDE. You need to override <code>deeplinkDataForFlashIDEPublish to provide your own default deeplink data dictionary.</code></li></ul>
	 * </ul>
	 * 
	 * <p>The DocumentController should not be used directly as a DocumentClass, It must always
	 * be subclassed.</p>
	 */
	public class DocumentController extends MovieClip
	{

		/**
		 * The site XML. This comes from loading an xml file provided by flashvars.sitexml.
		 * The name of the siteXML can be whatever you want.
		 */
		protected var siteXML:XML;
		
		/**
		 * Flashvars on this movie.
		 */
		protected var flashvars:Object;
		
		/**
		 * Deeplink data. An object with querystring parameters in an object. Parameters must
		 * be read using associative array notation.
		 */
		protected var deeplinkData:Dictionary;

		/**
		 * The loader used to load site xml
		 */
		private var siteXMLLoader:XMLLoader;
		
		/**
		 * Reference to this top level controller.
		 */
		private static var _siteInstance:*;
		
		/**
		 * A shared object for this application.
		 */
		public var sharedObject:SharedObject;

		/**
		 * Constructor for DocumentController instances. This should not
		 * be used directly, only subclassed.
		 */
		public function DocumentController()
		{
			flashvars = loaderInfo.parameters;
			if(Capabilities.playerType == "Standalone" || Capabilities.playerType == "External") flashvars = flashvarsForFlashIDEPublish();
			if(!flashvars.sitexml) throw new Error("No sitexml property was found in flashvars.");
			siteXMLLoader = new XMLLoader();
			siteXMLLoader.addEventListener(Event.COMPLETE,onSiteXMLComplete);
			siteXMLLoader.load(new URLRequest(flashvars.sitexml));
			DocumentController._siteInstance = this;
		}
		
		/**
		 * When the site xml completes loading.
		 */
		protected function onSiteXMLComplete(e:Event):void
		{
			siteXML = siteXMLLoader.data;
			siteXMLLoader.removeEventListener(Event.COMPLETE,onSiteXMLComplete);
			siteXMLLoader = null;
			
			handleSiteXML(siteXML);
			restoreSharedObject();
			handleFlashVars(flashvars);
			
			if(Capabilities.playerType == "Standalone" || Capabilities.playerType == "External")
			{
				deeplinkData = deeplinkDataForFlashIDEPublish();
				handleDeeplinkData(deeplinkData);
			}
			else
			{
				if(QueryString.HasParams())
				{
					deeplinkData = QueryString.ReadParams();
					handleDeeplinkData(deeplinkData);
				}
			}
			setupComplete();
		}
		
		/**
		 * The instance of the site controller.
		 */
		public static function get Instance():*
		{
			return DocumentController._siteInstance;
		}
		
		/**
		 * A method you can override to accept the deeplink params provided
		 * in a query string. This is part of the startup sequence and will
		 * be called automatically.
		 */
		protected function handleDeeplinkData(deeplinkData:Dictionary):void{}
		
		/**
		 * A method you can override to accept the flash vars on the movie.
		 * This is part of the startup sequence and will be called automatically.
		 */
		protected function handleFlashVars(flashvars:Object):void{}
		
		/**
		 * A method you can override to handle the site xml file after it's been
		 * loaded. This is part of the startup sequence and will be called automatically.
		 */
		protected function handleSiteXML(siteXML:XML):void{}

		/**
		 * A method you should override that provides the final hook in the
		 * chain of setup method calls. This is part of the startup sequence
		 * and will be called automatically.
		 */
		protected function setupComplete():void{}
		
		/**
		 * A method you can override to restore a shared object from disk.
		 * 
		 * @example Using the sharedObject property to restore the shared object to:
		 * <listing>	
		 * override protected function restoreSharedObject():void
		 * {
		 *   sharedObject = SharedObject.getLocal("test");
		 * }
		 * </listing>
		 */
		protected function restoreSharedObject():void{}
		
		/**
		 * A convenience method for flushing the sharedObject property on this
		 * site controller to disk.
		 * 
		 * @return	A property from the SharedObjectFlushStatus class.
		 */
		public function flushSharedObject():String
		{
			return sharedObject.flush();
		}
		
		/**
		 * A method you can override when publishing from the flash IDE to provide
		 * a default set of flash vars. This is because flashvars won't exist when
		 * publishing from the flash IDE.
		 */
		protected function flashvarsForFlashIDEPublish():Object
		{
			throw new Error("Running this movie from the Flash IDE requires you to override the 'flashvarsForFlashIDEPublish' method on you're document controller.");			
		}
		
		/**
		 * A method you can override when publishing from the flash IDE to provide
		 * a default set of deeplink data. This is because flashvars won't exist when
		 * publishing from the flash IDE.
		 */
		protected function deeplinkDataForFlashIDEPublish():Dictionary
		{
			throw new Error("Running this movie from the Flash IDE requires you to override the 'deeplinkDataForFlashIDEPublish' method on you're document controller.");
		}
	}
}