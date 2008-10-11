/*                   __    __                         __                       __         
 *                  /\ \__/\ \__                     /\ \                     /\ \        
 *       __   __  __\ \ ,_\ \ ,_\    __   _ __   ____\ \ \___      __     _ __\ \ \/'\    
 *     /'_ `\/\ \/\ \\ \ \/\ \ \/  /'__`\/\`'__\/',__\\ \  _ `\  /'__`\  /\`'__\ \ , <    
 *    /\ \_\ g \ \_u \\ \ t_\ \ t_/\  __e\ \ \/r\__, `s\ \ \ \ h/\ \L\.a_\ \ r/ \ \ \\`k  
 *    \ \____ \ \____/ \ \__\\ \__\ \____\\ \_\\/\____/ \ \_\ \_\ \__/.\_\\ \_\  \ \_\ \_\
 *     \/___L\ \/___/   \/__/ \/__/\/____/ \/_/ \/___/   \/_/\/_/\/__/\/_/ \/_/   \/_/\/_/
 *       /\____/                                                                          
 *       \_/__/                                                                           
 */
package net.guttershark.control
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.filters.BlurFilter;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.pixelbreaker.ui.osx.MacMouseWheel;
	
	import net.guttershark.display.CoreSprite;
	import net.guttershark.managers.LayoutManager;
	import net.guttershark.model.Model;
	import net.guttershark.util.PlayerUtils;
	import net.guttershark.util.Tracking;
	import net.guttershark.util.XMLLoader;
	import net.guttershark.util.akamai.Ident;

	//<li><strong>(in development)trackingMonitor</strong> (Boolean) - Connect to the tracking monitor, and send notifications from the javascript tracking library to the trackingMonitor.</li>
	//<li><strong>(in development)trackingSimulateXMLFile</strong> (String) - The path to a tracking xml file to use for making simulated tracking calls. This is specifically for when you're in the Flash IDE and need to at least simulate tracking calls for QA. The tags get sent to the tracking monitor.</li>


	/**
	 * The DocumentController class is the document class for an FLA, it contains
	 * default startup functionality that you can hook into, and all logic
	 * is controllable through flashvars.
	 * 
	 * The DocumentController also detects bandwidth, based off of the swf size
	 * and how much time it took to download.
	 * 
	 * <p>Available FlashVar Properties:</p>
	 * <ul>
	 * <li><strong>akamaiHost</strong> (String) - An akamai host address to use for the ident service. EX: 'http://cp44952.edgefcs.net/'</li>
	 * <li><strong>initServices</strong> (Boolean) - Initialize the <code><em>ServiceManager</em></code>, with all of the service declarations defined in a model.xml file.</li>
	 * <li><strong>macMouseWheel</strong> (Boolean) - Initialize MacMouseWheel.</li>
	 * <li><strong>model</strong> (String) - Specify an XML file to load as the site's model file. Specify a file name like "model.xml".</li>
	 * <li><strong>onlineStatus</strong> (Boolean) - Ping for online status.</li>
	 * <li><strong>onlineStatusPingFrequency</strong> (Number) - Specify the ping time in milliseconds. The default is 60000 (1 minute).</li>
	 * <li><strong>onlineStatusPingURL</strong> (String) - Specify the URL to an image to ping for online status. The default is "./ping.png".</li>
	 * <li><strong>swfAddress</strong> (Boolean) - Specify whether or not to listen for SWFAddress change events.</li>
	 * </ul>
	 * 
	 * <p>Flashvar properties can be supplied when running in the Flash IDE 
	 * by overriding the <code><a href="#flashvarsForStandalone()">flashvarsForStandalone()</a></code> 
	 * method. Otherwise you <strong>must</strong> declare the flashvars on the flash object in HTML.</p>
	 * 
	 * @example Overriding the flashvarsForStandalone method to provide flashvars for IDE development:
	 * <listing>	
	 * override protected function flashvarsForStandalone():Object
	 * {
	 *     return {model:"model.xml",initServices:true};
	 * }	
	 * </listing>
	 * 
	 * @example Declaring flashvars on a Flash object with SWFObject:
	 * <listing>	
	 * &lt;script type="text/javascript"&gt;
	 *     // &lt;![CDATA[
	 *     ...
	 *     var so = new SWFObject("main.swf", "flaswf", "100%", "100%", "9", "#000");
	 *     so.addVariable("model","model.xml");
	 *     so.addVariable("initServices","true");
	 *     ...
	 *     // ]]&gt;
	 * &lt;/script&gt;
	 * </listing> 
	 */
	public class DocumentController extends CoreSprite
	{
	
		/**
		 * The KiloBytes per second that the movie downloaded at.
		 */
		public static var KBPS:Number;
		
		/**
		 * A friendlier representation of the bandwidth.
		 * 
		 * <ul>
		 * <li>If kpbs is lower than 5, this is set to "trickle", meaning 56Kb dial up or slower.</li>
		 * <li>If kbps is lower than 32, this is set to "low", generally meaning a slow DSL.</li>
		 * <li>If kbps is lower than 132, this is set to "med", generally meaning an ok T1 line.</li>
		 * <li>If kpbs is higher than 132, this is set to "high", which could be a dsl,cable,or t1 that's 
		 * performing very well.</li>
		 * </ul>
		 */
		public static var bandwidth:String;
		
		/**
		 * The raw benchmark that was calculated for the cpuEstimation.
		 */
		public static var cpuBenchmark:Number;
		
		/**
		 * An estimation for cpu speed - fast, med, or slow.
		 */
		public static var cpuEstimation:String;
		
		/**
		 * The model XML - this is the xml that gets loaded from flashvars.model property.
		 */
		public var model:XML;
		
		/**
		 * The flashvars on this movie.
		 */
		public var flashvars:Object;

		/**
		 * The loader used to load site model xml file.
		 */
		private var modelXMLLoader:XMLLoader;
		
		/**
		 * An akamai Ident instance.
		 */
		private var ident:Ident;

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
		 * Online indicator.
		 */
		public var online:Boolean;
		
		/**
		 * The trackingMonitor connection if required.
		 */
		private var lc:LocalConnection;
		
		/**
		 * Loader for tracking xml when needed;
		 */
		private var trackingXMLLoader:XMLLoader;
		
		/**
		 * The start time of the first progress event from the swf downloading.
		 */
		private var startTime:Number;
		
		/**
		 * The end time after the swf has downloaded.
		 */
		private var endTime:Number;
		
		/**
		 * The movies total bytes.
		 */
		private var totalBytes:Number;

		/**
		 * Constructor for DocumentController instances. This should not
		 * be used directly, only subclassed as a Document Class for an FLA.
		 */
		public function DocumentController()
		{
			super();
			loaderInfo.addEventListener(Event.COMPLETE,onSWFComplete);
			stage.stageFocusRect=false;
			initStage();
			online = true;
			setupFlashvars();
			LayoutManager.SetStageReference(stage);
			if(flashvars.macMouseWheel) MacMouseWheel.setup(stage);
			if(flashvars.swfAddress && !utils.player.isStandAlonePlayer() && !utils.player.isIDEPlayer()) SWFAddress.addEventListener(SWFAddressEvent.CHANGE,swfAddressChange);
			if(flashvars.trackingSimulateXMLFile) setupSimulateTracking();
			if(flashvars.trackingMonitor) setupTrackingMonitor();
			if(flashvars.model) loadModel();
			if(flashvars.akamaiHost) loadAkamai();
			if(flashvars.onlineStatus) initOnlineStatus();
			if(!flashvars.model)
			{
				initModel();
				if(utils.player.isIDEPlayer()||utils.player.isStandAlonePlayer()) initPathsForStandalone();
				restoreSharedObject();
			}
		}
		
		/**
		 * On swf complete loaded.
		 */
		private function onSWFComplete(e:Event):void
		{
			startTime = 0;
			endTime = getTimer();
			totalBytes = loaderInfo.bytesTotal;
			loaderInfo.removeEventListener(Event.COMPLETE,onSWFComplete);
			var kbytes:Number = (totalBytes/1024);
			KBPS = Math.round((kbytes/Math.ceil(((endTime-startTime)/1000))));
			bandwidth="high";
			if(KBPS<5)bandwidth="trickle";
			if(KBPS<32)bandwidth="low";
			if(KBPS<132)bandwidth="med";
			if(KBPS>=(kbytes-1))bandwidth="high";
			endTime = NaN;
			startTime = NaN;
			totalBytes = NaN;
			var mc:MovieClip = new MovieClip();
			mc.graphics.beginFill(0xFF0066);
			mc.graphics.drawRect(0, 0, 200, 200);
			mc.graphics.endFill();
			var blurFilter:BlurFilter = new BlurFilter(4,4,1);
			var filters:Array = [];
			var passes:int = 3;
			var h:int = 0;
			var i:int = 0;
			var t:Number;
			var benchmark:Number;
			for(h;h<passes;h++)
			{
				t = getTimer();
				for(i=0;i<((h+1)*200);i++)
				{
					filters.push(blurFilter);
					mc.filters = filters;
				}
				benchmark = (getTimer() - t);
				filters = [];
			}
			if(benchmark<45)cpuEstimation="fast";
			else if(benchmark<80)cpuEstimation="medium";
			else cpuEstimation="slow";
			if(!flashvars.model) setupComplete();
		}
		
		/**
		 * A stub method you can override to initialize stage properties.
		 */
		protected function initStage():void{}
		
		/**
		 * Setup the flash vars on this movie.
		 */
		private function setupFlashvars():void
		{
			if(utils.player.isStandAlonePlayer() || utils.player.isIDEPlayer()) flashvars = flashvarsForStandalone();
			else flashvars = this.root.loaderInfo.parameters;
		}
		
		/**
		 * A method you can override to restore a shared object from disk.
		 * 
		 * @example Using the sharedObject property to restore the shared object to:
		 * <listing>	
		 * override protected function restoreSharedObject():void
		 * {
		 *     sharedObject = SharedObject.getLocal("test");
		 *     ml.sharedObject = sharedObject;
		 * }
		 * </listing>
		 * 
		 * <span class="hide">
		 *  <span class="scaffold method">
		 * 	//hook into restoring a shared object.
		 * 	override protected function restoreSharedObject():void
		 * 	{
		 * 	    //super();
		 * 	    //ml.sharedObject = SharedObject.getLocal("myapp");
		 * 	}
		 * 	</span>
		 * </span>
		 */
		protected function restoreSharedObject():void{}
		
		/**
		 * A method you can override to hook into SWFAddress change events.
		 */
		protected function swfAddressChange(sae:SWFAddressEvent):void{}
		
		/**
		 * Setup tracking for all AS implemented tracking.
		 */
		private function setupSimulateTracking():void
		{
			trackingXMLLoader = new XMLLoader();
			var x:String = (flashvars.trackingXMLFile) ? flashvars.trackingXMLFile : "./tracking.xml";
			trackingXMLLoader.contentLoader.addEventListener(Event.COMPLETE,ontc);
			trackingXMLLoader.load(new URLRequest(x));
		}
		
		/**
		 * Setup connections for the tracking monitor, and listen for
		 * external interface calls.
		 */
		private function setupTrackingMonitor():void
		{
			if((utils.player.isStandAlonePlayer() || utils.player.isIDEPlayer())) return;
			lc = new LocalConnection();
			lc.addEventListener(StatusEvent.STATUS, onLCStatus);
			ExternalInterface.addCallback("tracked", onJSTrack);
		}
		
		/**
		 * Load the site xml.
		 */
		private function loadModel():void
		{
			modelXMLLoader = new XMLLoader();
			modelXMLLoader.contentLoader.addEventListener(Event.COMPLETE,onSiteXMLComplete);
			modelXMLLoader.load(new URLRequest(flashvars.model || flashvars.siteXML));
		}
		
		/**
		 * A method you can override to intialize path logic with the
		 * model, when running in the Flash IDE.
		 * 
		 * <p>This will only execute if you're running the player as
		 * standalone.</p>
		 * 
		 * <p>See the lib/js/guttershark.js file</p>
		 */
		protected function initPathsForStandalone():void{}
		
		/**
		 * Hits an akamai ident service.
		 */
		private function loadAkamai():void
		{
			ident = new Ident();
			ident.contentLoader.addEventListener(Event.COMPLETE, onAkamaiIdentComplete);
			ident.findBestIPForAkamaiApplication(flashvars.akamaiHost);
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
			if(flashvars.onlineStatusPingURL) pingimg = new URLRequest(flashvars.onlineStatusPingURL); 
			else pingimg = new URLRequest("./ping.png");
			var nocache:URLRequestHeader = new URLRequestHeader("Cache-Control","no-cache");
			pingimg.requestHeaders = [nocache];
			if(flashvars.onlineStatusPingFrequency) statusPingTimer = new Timer(flashvars.onlineStatusPingFrequency);
			else statusPingTimer = new Timer(60000);
			statusPingTimer.addEventListener(TimerEvent.TIMER,onTimeToPing);
			statusPingTimer.start();
		}
		
		/**
		 * A method you can override to initialize your own model - you should
		 * always call super.initModel().
		 * 
		 * @example A custom initModel method:
		 * <listing>	
		 * override protected function initModel():void
		 * {
		 *     super.initModel();
		 *     fm = FooBarModel.gi(); //your model
		 * }
		 * </listing>
		 * 
		 * <span class="hide">
		 *  <span class="scaffold method">
		 *  //initialize your model.
		 *  override protected function initModel():void
		 *  {
		 *      super.initModel();
		 *      //myModel = MyModel.gi();
		 *      //myModel.ml = ml //set the guttershark model on your model.
		 *  }
		 *  </span>
		 * </span>
		 */
		protected function initModel():void
		{
			if(model) ml.xml = model;
		}
		
		/**
		 * @private
		 * 
		 * When the site xml completes loading.
		 */
		private function onSiteXMLComplete(e:Event):void
		{
			model = modelXMLLoader.data;
			initModel();
			restoreSharedObject();
			modelXMLLoader.contentLoader.removeEventListener(Event.COMPLETE,onSiteXMLComplete);
			modelXMLLoader.dispose();
			modelXMLLoader = null;
			if(utils.player.isIDEPlayer() || utils.player.isStandAlonePlayer()) initPathsForStandalone();
			if(flashvars.initServices) ml.initServices();
			setupComplete();
		}
		
		/**
		 * On tracking xml load complete.
		 */
		private function ontc(e:Event):void
		{
			Tracking.simulationTrackingXML = trackingXMLLoader.data;
		}
				
		/**
		 * On call from ExternalInterface.. from javascript tracking framework.
		 */
		private function onJSTrack(msg:String):void
		{
			lc.send("TrackingMonitor","tracked",msg);
		}
		
		/**
		 * LocalConnection status event.
		 */
		private function onLCStatus(se:StatusEvent):void
		{
			switch (se.level)
			{
                case "status":
                    break;
                case "error":
                    trace("TrackingMonitor could not connect. Code: " + se.code);
                    break;
            }
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
		 * event handler method for akamai ident sniff.
		 */
		private function onAkamaiIdentComplete(e:Event):void
		{
			akamaiIdentComplete(XML(ident.contentLoader.data).ip.toString());
			ident.dispose();
			ident = null;
		}

		/**
		 * A method you should override that provides the final hook in the
		 * chain of setup method calls.
		 * 
		 * </p>setupComplete ensures that the model xml file has finished loading
		 * (if flashvars.model was set). But it will not wait for sniffBandwidth,
		 * or akamai idents.</p>
		 */
		protected function setupComplete():void{}
		
		/**
		 * A method you can override when publishing from the flash IDE to provide
		 * a default set of flashvars. Flashvars won't exist when
		 * publishing from the flash IDE, so in this case, you just return
		 * an Object with properties on it that fake what your flashvars will
		 * actually be when coming from HTML.
		 * 
		 * @return A generic object with hard code properties.
		 */
		protected function flashvarsForStandalone():Object
		{
			return {};
		}
		
		/**
		 * A method you can override when publishing from the flash IDE to provide
		 * a default set of querystring data.
		 * 
		 * @return A dictionary with deeplink keys and values.
		 */
		protected function queryStringForStandalone():Dictionary
		{
			return new Dictionary();
		}
		
		/**
		 * A method you can override to hook into the complete event from the akamai
		 * ident hit. This will only be called if you provided the <code><strong><em>akamaiHost</em></strong></code>
		 * property in flashvars.
		 * 
		 * <p>You should hook into this for two things.</p>
		 * <ul>
		 * <li>Set the <code>AkamaiNCManager.FMS_IP = ip;</code></li>
		 * <li>Set the <code>VideoPlayer.iNCManager = "net.guttershark.akamai.AkamaiNCManager";</code></li>
		 * </ul>
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