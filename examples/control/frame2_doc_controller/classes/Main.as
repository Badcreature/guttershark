package 
{
	import flash.display.MovieClip;
	import flash.events.Event;	

	public class Main extends MovieClip
	{
		public function Main()
		{
			stop();
			trace(this.loaderInfo.applicationDomain.hasDefinition("net.guttershark.display.buttons.MovieClipButton"));
			trace(this.loaderInfo.applicationDomain.hasDefinition("net.guttershark.managers.EventManager"));
			this.loaderInfo.addEventListener(Event.COMPLETE,onc);
		}
		private function onc(e:*):void
		{
			trace("COMPLETE");
			gotoAndStop(2);
			trace(this.loaderInfo.applicationDomain.hasDefinition("net.guttershark.display.buttons.MovieClipButton"));
			trace(this.loaderInfo.applicationDomain.hasDefinition("net.guttershark.managers.EventManager"));
		}	}}