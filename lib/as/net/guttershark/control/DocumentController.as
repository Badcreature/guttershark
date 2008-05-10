package net.guttershark.control
{

	import flash.events.HTTPStatusEvent;	
	import flash.events.IOErrorEvent;	
	import flash.events.TimerEvent;	
	import flash.utils.Timer;	
	import flash.net.URLRequestHeader;	
	import flash.display.Loader;	
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import net.guttershark.akamai.Ident;
	import net.guttershark.managers.PlayerManager;
	import net.guttershark.util.CPU;
	import net.guttershark.util.QueryString;
	import net.guttershark.util.XMLLoader;
	import net.guttershark.util.Bandwidth;
	import net.guttershark.managers.KeyboardEventManager;
	import net.guttershark.managers.LanguageManager;
	
	/**
	 * The DocumentController class is the base Document Class for all sites. The DocumentController provides 
	 * default functionality for numerous things that are needed for 90% of flash sites. This should always
	 * be extended and never used directly.
	 * 
	 * <p>By providing any of the following flash var properties, you trigger some of the default functionality.</p>
	 * 
	 * <p>Available FlashVar Properties:</p>
	 * <ul>
	 * <li><strong>siteXML</strong> (String) - Specify an XML file to load as the site's XML file. Specify a file name like "site.xml".</li>
	 * <li><strong>sniffBandwidth</strong> (Boolean) - Sniff bandwidth on startup. The default file of "./bandwidth.jpg" will attempt to be loaded.</li>
	 * <li><strong>sniffCPU</strong> (Boolean) - Sniff CPU on startup.</li>
	 * <li><strong>akamaiHost</strong> (String) - An akamai host address to use for the ident service. EX: 'http://cp44952.edgefcs.net/'</li>
	 * <li><strong>onlineStatus</strong> (Boolean) - Ping for online status.</li>
	 * <li><strong>onlineStatusPingFrequency</strong> (Number) - Specify the ping time in milliseconds. The default is 60000.</li>
	 * </ul>
	 */
	public class DocumentController extends MovieClip
	{

		/**
		 * The site XML. This comes from loading an xml file provided by flashvars.siteXML property.
		 */
		protected var siteXML:XML;
		
		/**
		 * FlashVars on this movie.
		 */
		protected var flashvars:Object;

		/**
		 * The loader used to load site xml
		 */
		private var siteXMLLoader:XMLLoader;
		
		/**
		 * An akamai Ident instance.
		 */
		private var ident:Ident;

		/**
		 * Reference to this top level controller.
		 */
		private static var _siteInstance:*;
		
		/**
		 * An instance of a bandwidth object for bandwidth sniffing.
		 */
		private var _bandwidthSniffer:Bandwidth;

		/**
		 * A shared object for this application.
		 */
		public var sharedObject:SharedObject;
		
		/**
		 * A query string object used for deeplink data reading.
		 */
		public var queryString:QueryString;
		
		/**
		 * The document keyboard event manager.
		 * 
		 * @see net.guttershark.managers.KeyboardEventManager KeyboardEventManager class
		 */
		public var keyboardEventManager:KeyboardEventManager;

		/**
		 * The document language manager.
		 * 
		 * @see net.guttershark.managers.LanguageManager LanguageManager class
		 */
		public var languageManager:LanguageManager;
		
		/**
		 * The timer used to initiate the ping loader.
		 */
		private var statusPingTimer:Timer;

		/**
		 * A loader used for online status watching.
		 */
		private var statusLoader:Loader;
		
		/**
		 * The url request for the ping image.
		 */
		private var pingimg:URLRequest;
		
		/**
		 * The url request header that adds a no cache policy on the ping image.
		 */
		private var nocache:URLRequestHeader;
		
		/**
		 * Online indicator.
		 */
		private var online:Boolean;
		
		/**
		 * Constructor for DocumentController instances. This should not
		 * be used directly, only subclassed.
		 */
		public function DocumentController()
		{
			DocumentController._siteInstance = this;
			online = true;
			languageManager = new LanguageManager();
			keyboardEventManager = new KeyboardEventManager(stage);
			keyboardEventManager.scope = this;
			setupFlashvars();
			setupQueryString();
			restoreSharedObject();
			if(flashvars.sniffCPU) CPU.calculate();
			if(flashvars.sniffBandwidth) sniffBandwidth();
			if(flashvars.siteXML) loadSiteXML();
			if(flashvars.akamaiHost) loadAkamai();
			if(flashvars.onlineStatus) initOnlineStatus();
			if(!flashvars.siteXML) setupComplete();
		}
		
		/**
		 * Setup the flash vars on this movie.
		 */
		private function setupFlashvars():void
		{
			if(PlayerManager.IsStandAlonePlayer() || PlayerManager.IsIDEPlayer()) flashvars = flashvarsForStandalone();
			else flashvars = loaderInfo.parameters;
		}
		
		/**
		 * Setup the querystring data.
		 */
		private function setupQueryString():void
		{
			queryString = new QueryString();
			if(PlayerManager.IsStandAlonePlayer() || PlayerManager.IsIDEPlayer()) queryString.querystringData = deeplinkDataForQueryString();
		}
		
		/**
		 * Load the site xml.
		 */
		private function loadSiteXML():void
		{
			siteXMLLoader = new XMLLoader();
			siteXMLLoader.contentLoader.addEventListener(Event.COMPLETE,onSiteXMLComplete);
			siteXMLLoader.load(new URLRequest(flashvars.siteXML));
		}
		
		/**
		 * Sniff the client's bandwidth.
		 */
		private function sniffBandwidth():void
		{
			_bandwidthSniffer = new Bandwidth();
			_bandwidthSniffer.detect();
		}
		
		/**
		 * @private
		 * 
		 * When the site xml completes loading.
		 */
		protected function onSiteXMLComplete(e:Event):void
		{
			siteXML = siteXMLLoader.data;
			siteXMLLoader.contentLoader.removeEventListener(Event.COMPLETE,onSiteXMLComplete);
			siteXMLLoader.dispose();
			siteXMLLoader = null;
			setupComplete();
		}
		
		/**
		 * Start the online status watching.
		 */
		private function initOnlineStatus():void
		{
			statusLoader = new Loader();
			statusLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPingComplete);
			statusLoader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, onPingError);
			statusLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onPingError);
			statusLoader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,onPingError);
			statusLoader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR,onPingError);
			statusLoader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onPingStatus);
			pingimg = new URLRequest("http://www.rubyamf.org/ping.png");
			nocache = new URLRequestHeader("Cache-Control","no-cache");
			pingimg.requestHeaders = [nocache];
			if(flashvars.onlineStatusPingFrequency) statusPingTimer = new Timer(flashvars.onlineStatusPingFrequency);
			else statusPingTimer = new Timer(60000);
			statusPingTimer.addEventListener(TimerEvent.TIMER,onTimeToPing);
			statusPingTimer.start();
		}
	
		/**
		 * On ping complete.
		 */
		private function onPingComplete(e:Event):void
		{
			if(online) return;
			online = true;
			applicationOnline();
		}
		
		/**
		 * On a ping http status.
		 */
		private function onPingStatus(ht:HTTPStatusEvent):void
		{
			if(ht.status != 200 && ht.status != 0) throw new Error("HTTP Status Error, code:" + ht.status.toString());
		}

		/**
		 * On ping timer tick.
		 */
		private function onTimeToPing(e:*):void
		{
			statusLoader.load(pingimg);
		}

		/**
		 * On a ping error.
		 */
		private function onPingError(e:IOErrorEvent):void
		{
			if(!online) return;
			online = false;
			applicationOffline();
		}
		
		/**
		 * Hit an akamai ident service.
		 */
		private function loadAkamai():void
		{
			ident = new Ident();
			ident.contentLoader.addEventListener(Event.COMPLETE, onAkamaiIdentComplete);
			ident.findBestIPForAkamaiApplication(flashvars.akamaiHost);
		}
		
		/**
		 * event handler method for akamai ident sniff.
		 */
		private function onAkamaiIdentComplete(e:Event):void
		{
			akamaiIdentComplete(XML(ident.contentLoader.data).ip.toString());
			ident.dispose();
			ident = null;
		}
		
		/**
		 * The instance of the site controller. This will always return the lowest
		 * child in a chain of subclasses. If the DocumentController is extended by a class
		 * called Main, this would return an instance of Main.
		 * 
		 * @return The lowest child in the inheritance chain.
		 */
		public static function get Instance():*
		{
			return DocumentController._siteInstance;
		}

		/**
		 * A method you should override that provides the final hook in the
		 * chain of setup method calls.
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
		 * 
		 * @return A generic object with hard coded custom flashvar keys.
		 */
		protected function flashvarsForStandalone():Object
		{
			return {};		
		}
		
		/**
		 * A method you can override when publishing from the flash IDE to provide
		 * a default set of querystring data. The custom data get's set on the
		 * <code>queryString</code> property so you can continue to use that property
		 * without worrying about if your in the IDE or not.
		 * 
		 * @return A dictionary with deeplink keys and values.
		 */
		protected function deeplinkDataForQueryString():Dictionary
		{
			return new Dictionary();
		}
		
		/**
		 * A method you can override to hook into the complete event from the akamai
		 * ident hit. This will only be called if you did provide an <code>akamaiHost</code>
		 * property in flashvars.
		 * 
		 * <p>You should hook into this for two things.</p>
		 * <ul>
		 * <li>Set the <code>AkamaiNCManager.FMS_IP = ip;</code></li>
		 * <li>Set the <code>VideoPlayer.iNCManager = "net.guttershark.akamai.AkamaiNCManager";</code></li>
		 * <li>
		 * </p>
		 * 
		 * @param	ip	The IP that was found from the Ident service.
		 *
		 * @see net.guttershark.akamai.AkamaiNCManager AkamaiNCManager Class
		 */
		protected function akamaiIdentComplete(ip:String):void{}
		
		/**
		 * A method you can override to hook into the application offline event. This is only useful
		 * if you've opted into the <code>onlineStatus</code> flashvar property. 
		 */
		protected function applicationOffline():void{}
		
		/**
		 * A method you can override to hook into the application online event. This is only useful
		 * if you've opted into the <code>onlineStatus</code> flashvar property.
		 */
		protected function applicationOnline():void{}
		
		/**
		 * Stop the online status pinging.
		 */
		public function stopOnlineStatus():void
		{
			statusPingTimer.stop();
		}
		
		/**
		 * Start the online status pinging. The online status pinging will
		 * start by default if you specify the <code>onlineStatus</code> flashvar
		 * property. This should be used to restart the pinging if you stopped it
		 * at some point.
		 */
		public function startOnlineStatus():void
		{
			statusPingTimer.start();
		}
	}
}