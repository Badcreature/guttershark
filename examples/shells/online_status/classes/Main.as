package
{
	
	import net.guttershark.control.DocumentController;
	
	public class Main extends DocumentController 
	{
		
		public function Main()
		{
			super();
		}
		
		override protected function flashvarsForStandalone():Object
		{
			return {onlineStatus:true,onlineStatusPingFrequency:1000};
		}
		
		override protected function applicationOnline():void
		{
			trace("online");
		}
		
		override protected function applicationOffline():void
		{
			trace("offline");
		}
	}
}