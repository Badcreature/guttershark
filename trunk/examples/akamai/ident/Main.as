package 
{
	
	import net.guttershark.akamai.AkamaiNCManager;
	import net.guttershark.akamai.Ident;
	import net.guttershark.control.DocumentController;

	public class Main extends DocumentController
	{

		private var ident:Ident;

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
		}

		override protected function setupComplete():void
		{
		}	}}