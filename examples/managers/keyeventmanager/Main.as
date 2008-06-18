package 
{

	
	import net.guttershark.managers.KeyboardEventManager;
	import net.guttershark.control.DocumentController;
	
	public class Main extends DocumentController
	{
		
		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			keyboardEventManager = KeyboardEventManager.gi();
			keyboardEventManager.addMapping(stage, "CONTROL+SHIFT+M", onWhatever);
			keyboardEventManager.addMapping(stage,"Whatup",onWordup);
			keyboardEventManager.addMapping(stage,"f", onW);
			keyboardEventManager.addMapping(stage, " ", onSpace);
			keyboardEventManager.addMapping(stage,"CONTROL+SHIFT+F", onWhatever);
			keyboardEventManager.addMapping(stage,"CONTROL+SHIFT+F+M",onWhatever);
			keyboardEventManager.addMapping(stage,"CONTROL",onControl);
			keyboardEventManager.addMapping(stage,"CONTROL+m",onm);
			keyboardEventManager.addMapping(stage,"SHIFT",onW);
		}

		private function onm():void
		{
			trace("on ctrl m");
		}
		
		private function onControl():void
		{
			trace("on control");
		}
		
		private function onWhatever():void
		{
			trace("sequence matched");
		}
		
		private function onW():void
		{
			trace("on f");
		}
		
		private function onWordup():void
		{
			trace("typed wordup");
		}
		
		private function onSpace():void
		{
			trace("space pressed");
		}
	}}