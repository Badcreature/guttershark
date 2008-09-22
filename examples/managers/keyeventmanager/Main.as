package 
{
	import flash.text.TextField;
	
	import net.guttershark.control.DocumentController;
	import net.guttershark.managers.KeyManager;		

	public class Main extends DocumentController
	{
		
		public var textfeeld:TextField;

		private var keyboardEventManager:KeyManager;

		public function Main()
		{
			super();
		}
		
		override protected function setupComplete():void
		{
			keyboardEventManager = KeyManager.gi();
			keyboardEventManager.addMapping(stage, "CONTROL+SHIFT+M", onWhatever);
			keyboardEventManager.addMapping(stage,"Whatup",onWordup);
			keyboardEventManager.addMapping(stage,"f", onW);
			keyboardEventManager.addMapping(stage, " ", onSpace);
			keyboardEventManager.addMapping(stage,"CONTROL+SHIFT+F", onWhatever);
			keyboardEventManager.addMapping(stage,"CONTROL+SHIFT+F+M",onWhatever);
			keyboardEventManager.addMapping(stage,"CONTROL",onControl);
			keyboardEventManager.addMapping(stage,"CONTROL+m",onm);
			keyboardEventManager.addMapping(stage,"SHIFT",onW);
			
			keyboardEventManager.addMapping(textfeeld, "ENTER", onTFEnter);
		}
		
		public function onTFEnter():void
		{
			trace("YOU PRESSED ENTER");
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