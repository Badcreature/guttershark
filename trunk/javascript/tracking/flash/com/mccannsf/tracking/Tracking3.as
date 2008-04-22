package com.mccannsf.tracking
{
	import flash.external.ExternalInterface;
	public class Tracking3
	{
		public static function Track(xmlid, overrideData = null, appendData = null)
		{
			ExternalInterface.call("flashTrack",xmlid,overrideData,appendData);
		}
	}
}