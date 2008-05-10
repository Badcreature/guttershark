package 
{

	import flash.events.Event;
	import net.guttershark.akamai.Ident;
	import net.guttershark.control.DocumentController;

	public class Main extends DocumentController
	{

		private var ident:Ident;

		public function Main():void
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			ident = new Ident();
			ident.contentLoader.addEventListener(Event.COMPLETE, onc);
			ident.findBestIPForAkamaiApplication("http://cp44952.edgefcs.net/");
		}
		
		private function onc(e:Event):void
		{
			trace(ident.ip);
		}	}}