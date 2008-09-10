package 
{
	
	import fl.video.VideoPlayer;	

	import net.guttershark.util.akamai.AkamaiNCManager;
	import net.guttershark.control.DocumentController;

	public class Main extends DocumentController
	{

		public function Main():void
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {akamaiHost:"http://cp44952.edgefcs.net/"};
		}
		
		override protected function akamaiIdentComplete(ip:String):void
		{
			trace(ip);
			AkamaiNCManager.FMS_IP = ip;
			VideoPlayer.iNCManagerClass = "net.guttershark.akamai.AkamaiNCManager";
		}

		override protected function setupComplete():void
		{
		}	}}