package net.guttershark.util
{
	import flash.events.StatusEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	
	import net.guttershark.managers.PlayerManager;		

	/**
	 * The Tracking Class sends tracking calls through
	 * ExternalInterface to the tracking framework.
	 * 
	 * @see external: guttershark/lib/js/tracking.
	 */
	public class Tracking
	{
		
		/**
		 * A tracking xml file used for sending simulated tracking
		 * messages to the tracking monitor. This is specifically
		 * useful for when you're in the Flash IDE and need to
		 * verify tracking.
		 */
		public static var SimulationTrackingXML:XML;
		
		/**
		 * Local connection for the tracking monitor.
		 */
		private static var lc:LocalConnection;

		/**
		 * Make a tracking call. If SimulateTrackingXML is set, it will
		 * only send 'simulated' tracking tags to the tracking monitor.
		 * 
		 * @param	xmlid	The id in tracking.xml to make tracking calls for.
		 * @param	appendData	Any dynamic data to be sent to the tracking framework.
		 */
		public static function Track(xmlid:String, appendData:Array = null):void
		{
			Assert.NotNull(xmlid, "Parameter xmlid cannot be null.");
			if(SimulationTrackingXML)
			{
				SimulateCall(xmlid,appendData);
				return;
			}
			if(PlayerManager.IsStandAlonePlayer() || PlayerManager.IsIDEPlayer()) return;
			ExternalInterface.call("flashTrack",xmlid,appendData);
		}
		
		/**
		 * Send a simulated message to the tracking monitor.
		 */
		private static function SimulateCall(id:String, webAppendData:Array = null):void
		{
			if(!lc) lc = new LocalConnection();
			lc.addEventListener(StatusEvent.STATUS, ons);
			var n:XMLList = SimulationTrackingXML.track.(@id == id);
			if(n.webtrends != undefined) SimulateWebtrends(n.webtrends.toString());
			if(n.atlas != undefined) SimulateAtlas(n.atlas.toString());
			if(n.ganalytics != undefined) SimulateGoogle(n.ganalytics.toString());
		}
		
		private static function ons(se:StatusEvent):void{}
		
		/**
		 * Simulate a webtrends call.
		 */
		private static function SimulateWebtrends(node:String,appendArr:Array = null):void
		{
			var parts:Array = node.toString().split(",");
			var dscuri:String = parts[0];
			var ti:String = parts[1];
			var cg_n:String = parts[2];
			if(appendArr && appendArr[0]) dscuri += appendArr[0];
			if(appendArr && appendArr[1]) ti += appendArr[1];
			if(appendArr && appendArr[2]) cg_n += appendArr[2];
			var newtag:String = "wt::" + dscuri + "," + ti + "," + cg_n;
			lc.send("TrackingMonitor","tracked",newtag);
		}
		
		/**
		 * Simulate an Atlas track.
		 */
		private static function SimulateAtlas(str:String):void
		{
			lc.send("TrackingMonitor","tracked","al::"+str);
		}
		
		/**
		 * Simulate a google analytics track.
		 */
		private static function SimulateGoogle(str:String):void
		{
			lc.send("TrackingMonitor","tracked","ga::"+str);
		}
	}
}