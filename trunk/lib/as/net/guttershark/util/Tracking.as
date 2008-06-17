package net.guttershark.util
{
	
	import net.guttershark.managers.PlayerManager;
	import flash.external.ExternalInterface;

	/**
	 * The Tracking class implements tracking calls.
	 */
	public class Tracking
	{
		
		/**
		 * Make a tracking call into the javascript tracking framework.
		 * 
		 * @param	xmlid	The id in tracking.xml to make tracking calls for.
		 * @param	appendData	Any dynamic data to be sent to the tracking framework.
		 */
		public static function TrackThroughJS(xmlid:String, appendData:Array = null):void
		{
			Assert.NotNull(xmlid, "Parameter xmlid cannot be null.");
			if(PlayerManager.IsStandAlonePlayer() || PlayerManager.IsIDEPlayer()) return;
			ExternalInterface.call("flashTrack",xmlid,appendData);
		}
		
		/**
		 * Tracking calls from EventManager cycle through this method, only when
		 * you opted in to track the events.
		 * 
		 * @param	eventFunctionCallback	This will be a method name that was called, like onMyClipClick.
		 */
		public static function TrackFromEventManager(eventFunctionCallback:String):void
		{
			Tracking.TrackThroughJS(eventFunctionCallback);
		}
	}
}