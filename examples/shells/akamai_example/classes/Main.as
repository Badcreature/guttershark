package
{
	import fl.video.VideoPlayer;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.util.akamai.AkamaiNCManager;	

	public class Main extends DocumentController
	{
		
		public function Main()
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {akamaiHost:"http://cp44952.edgefcs.net/"};
		}
		
		override protected function akamaiIdentComplete(ip:String):void
		{
			trace("AKAMAI IP:", ip);
			AkamaiNCManager.FMS_IP = ip;
			VideoPlayer.iNCManagerClass = "net.guttershark.util.akamai.AkamaiNCManager";
		}
	}
}
