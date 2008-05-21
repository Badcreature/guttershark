package net.guttershark.util
{
	
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;

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
			if(Capabilities.playerType == "Standalone" || Capabilities.playerType == "External") return;
			ExternalInterface.call("flashTrack",xmlid,appendData);
		}
	}
}