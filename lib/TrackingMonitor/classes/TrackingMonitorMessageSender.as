package  
{
	import flash.events.StatusEvent;	
	import flash.net.LocalConnection;
	public class TrackingMonitorMessageSender 
	{
		public static function Send(lc:LocalConnection,msg:String):void
		{
			lc.send("TrackingMonitor", "tracked", msg);
		}
		public static function HandleStatus(se:StatusEvent):void
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
	}}