package
{
	import flash.display.MovieClip;
	
	import gs.TweenMax;	

	import net.guttershark.control.DocumentController;
	
	public class Main extends DocumentController 
	{
	
		public var statusIndicator:MovieClip;

		public function Main()
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {onlineStatus:true, onlineStatusPingFrequency:1000};
		}
		
		override protected function applicationOnline():void
		{
			statusIndicator.label.text = "online";
			TweenMax.to(statusIndicator,.3,{tint:0x00FF00});
		}

		override protected function applicationOffline():void
		{
			statusIndicator.label.text = "offline";
			TweenMax.to(statusIndicator,.3,{tint:0xFF0000});
		}
	}
}