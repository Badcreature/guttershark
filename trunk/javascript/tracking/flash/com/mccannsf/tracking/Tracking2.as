import flash.external.ExternalInterface;
class com.mccannsf.tracking.Tracking2
{	
	public static function Track(xmlid,overrideData,appendData)
	{
		ExternalInterface.call("flashTrack",xmlid,overrideData,appendData);
	}
}