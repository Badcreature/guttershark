package  
{
	import flash.external.ExternalInterface;	
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.display.Sprite;
	public class SwfComTrackingController extends Sprite
	{
		private var lc:LocalConnection;
		public function SwfComTrackingController()
		{
			trace("WORD");
			lc = new LocalConnection();
			lc.addEventListener(StatusEvent.STATUS,TrackingMonitorMessageSender.HandleStatus);
			ExternalInterface.addCallback("tracked", onJSTrack);
		}
		
		/**
		 * On call from ExternalInterface.. from javascript tracking framework.
		 */
		private function onJSTrack(msg:String):void
		{
			lc.send("TrackingMonitor","tracked",msg);
		}	}}